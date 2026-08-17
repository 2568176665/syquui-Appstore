#!/usr/bin/env python3
"""Small, explicit Compose YAML reader for 1Panel App Builder.

This is intentionally not a full Compose implementation. It only reads fields
needed by the draft generator and refuses/marks long forms it cannot safely
round-trip.
"""
from __future__ import annotations

import argparse
import json
import sys
from typing import Any

try:
    import yaml
except Exception as exc:  # pragma: no cover
    print(f"PyYAML is required: {exc}", file=sys.stderr)
    raise SystemExit(3)


def load() -> dict[str, Any]:
    try:
        data = yaml.safe_load(sys.stdin.read()) or {}
    except Exception as exc:
        print(f"invalid YAML: {exc}", file=sys.stderr)
        raise SystemExit(2)
    if not isinstance(data, dict) or not isinstance(data.get("services"), dict):
        print("Compose file must contain a services mapping", file=sys.stderr)
        raise SystemExit(2)
    return data


def service(data: dict[str, Any], name: str) -> dict[str, Any]:
    value = data["services"].get(name)
    if not isinstance(value, dict):
        print(f"service not found: {name}", file=sys.stderr)
        raise SystemExit(4)
    return value


def scalar(value: Any) -> str:
    if value is None:
        return ""
    if isinstance(value, bool):
        return "true" if value else "false"
    return str(value)


def normalize_service(s: dict[str, Any]) -> dict[str, Any]:
    out: dict[str, Any] = {"keys": list(s.keys()), "image": scalar(s.get("image")), "ports": [], "volumes": [], "environment": [], "env_file": []}
    ports = s.get("ports") or []
    if isinstance(ports, list):
        for item in ports:
            if isinstance(item, (str, int)):
                out["ports"].append(str(item))
            elif isinstance(item, dict):
                target=item.get("target")
                if target is None:
                    out["ports"].append("__LONG_INVALID__"+json.dumps(item, ensure_ascii=False, sort_keys=True))
                else:
                    published=item.get("published", target)
                    proto=item.get("protocol")
                    mapping=f"{published}:{target}"
                    if proto and str(proto).lower() != "tcp": mapping += f"/{proto}"
                    out["ports"].append(mapping)
    volumes=s.get("volumes") or []
    if isinstance(volumes,list):
        for item in volumes:
            out["volumes"].append(item if isinstance(item,str) else "__LONG__"+json.dumps(item, ensure_ascii=False, sort_keys=True, default=str))
    env=s.get("environment")
    if isinstance(env,dict):
        out["environment"]=[f"{k}={scalar(v)}" for k,v in env.items()]
    elif isinstance(env,list):
        out["environment"]=[scalar(x) for x in env]
    elif env is not None:
        out["environment"]=["__INVALID__"+json.dumps(env, ensure_ascii=False, default=str)]
    ef=s.get("env_file")
    if isinstance(ef,str): out["env_file"]=[ef]
    elif isinstance(ef,list):
        for item in ef:
            if isinstance(item,str): out["env_file"].append(item)
            else: out["env_file"].append("__LONG__"+json.dumps(item, ensure_ascii=False, sort_keys=True, default=str))
    elif ef is not None:
        out["env_file"]=["__LONG__"+json.dumps(ef, ensure_ascii=False, sort_keys=True, default=str)]
    return out


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("action")
    p.add_argument("service", nargs="?")
    args = p.parse_args()
    data = load()

    if args.action == "validate":
        return
    if args.action == "service-count":
        print(len(data["services"]))
        return
    if args.action == "service-names":
        print("\n".join(data["services"].keys()))
        return
    if args.action == "inspect-all":
        result={"count": len(data["services"]), "names": list(data["services"].keys()), "services": {}}
        for name, value in data["services"].items():
            if isinstance(value, dict): result["services"][name]=normalize_service(value)
        print(json.dumps(result, ensure_ascii=False))
        return
    if args.action == "first-service":
        print(next(iter(data["services"]), ""))
        return
    if not args.service:
        p.error("service name required for this action")
    s = service(data, args.service)

    if args.action == "image":
        print(scalar(s.get("image")))
    elif args.action == "keys":
        print("\n".join(s.keys()))
    elif args.action == "ports":
        ports = s.get("ports") or []
        if not isinstance(ports, list):
            raise SystemExit(5)
        for item in ports:
            if isinstance(item, (str, int)):
                print(str(item))
            elif isinstance(item, dict):
                target = item.get("target")
                if target is None:
                    print("__LONG_INVALID__" + json.dumps(item, ensure_ascii=False, sort_keys=True))
                    continue
                published = item.get("published", target)
                proto = item.get("protocol")
                mapping = f"{published}:{target}"
                if proto and str(proto).lower() != "tcp":
                    mapping += f"/{proto}"
                print(mapping)
            else:
                print("__LONG_INVALID__" + json.dumps(item, ensure_ascii=False, default=str))
    elif args.action == "volumes":
        volumes = s.get("volumes") or []
        if not isinstance(volumes, list):
            raise SystemExit(5)
        for item in volumes:
            if isinstance(item, str):
                print(item)
            else:
                print("__LONG__" + json.dumps(item, ensure_ascii=False, sort_keys=True, default=str))
    elif args.action == "environment":
        env = s.get("environment")
        if env is None:
            return
        if isinstance(env, dict):
            for k, v in env.items():
                print(f"{k}={scalar(v)}")
        elif isinstance(env, list):
            for item in env:
                print(scalar(item))
        else:
            print("__INVALID__" + json.dumps(env, ensure_ascii=False, default=str))
    elif args.action == "env-file":
        value = s.get("env_file")
        if value is None:
            return
        if isinstance(value, str):
            print(value)
        elif isinstance(value, list):
            for item in value:
                if isinstance(item, str):
                    print(item)
                elif isinstance(item, dict) and isinstance(item.get("path"), str):
                    print("__LONG__" + json.dumps(item, ensure_ascii=False, sort_keys=True))
                else:
                    print("__LONG__" + json.dumps(item, ensure_ascii=False, default=str))
        elif isinstance(value, dict) and isinstance(value.get("path"), str):
            print("__LONG__" + json.dumps(value, ensure_ascii=False, sort_keys=True))
        else:
            print("__LONG__" + json.dumps(value, ensure_ascii=False, default=str))
    else:
        p.error(f"unknown action: {args.action}")


if __name__ == "__main__":
    main()
