# My `code-server` setup

```bash
fly machine run . \
  -p 443:8080/tcp:tls \
  -p 4000:4000/tcp:tls \
  -p 4001:4001/tcp:tls \
  -p 4002:4002/tcp:tls \
  -p 4003:4003/tcp:tls \
  -p 4004:4004/tcp:tls \
  --size shared-cpu-8x \
  --region cdg \
  --volume storage:/workspace \
  --env FLY_REMOTE_BUILDER_HOST_WG=1 \
  -a cyriac-workspace
```