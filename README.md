# zrok - Secure Internet Sharing Made Simple

![zrok logo](docs/images/zrok_cover.png)

**Share anything, anywhere, instantly. Enterprise reliability. No firewall changes. No port forwarding. No hassle.**

`zrok` lets you securely share web services, files, and network resources with anyone--whether they're across the internet or your private network. Built on zero-trust networking, it works through firewalls and NAT without requiring any network configuration changes.

## Quick Start

Get sharing in under 2 minutes:

1. **Install zrok** for your platform
2. **Get an account**: `zrok invite`
3. **Enable sharing**: `zrok enable`

That's it! Now you can share anything:

```bash
# Share a web service publicly
$ zrok share public localhost:8080

# Share files as a network drive
$ zrok share public --backend-mode drive ~/Documents

# Share privately with other zrok users
$ zrok share private localhost:3000
```

![zrok Web Console](docs/images/zrok_web_console.png)

## What You Can Share

### Web Services
Instantly make local web apps accessible over the internet:

```bash
$ zrok share public localhost:8080
```
![zrok share public](docs/images/zrok_share_public.png)

### Files & Directories
Turn any folder into a shareable network drive:

```bash
$ zrok share public --backend-mode drive ~/Repos/zrok
```
![zrok share public -b drive](docs/images/zrok_share_public_drive.png)
![mounted zrok drive](docs/images/zrok_share_public_drive_explorer.png)

### Private Resources
Share TCP/UDP services securely with other zrok users--no public internet exposure.

## Key Features

- **Zero Configuration**: Works through firewalls, NAT, and corporate networks
- **Secure by Default**: End-to-end encryption with zero-trust architecture
- **Public & Private Sharing**: Share with anyone or just specific users
- **Multiple Protocols**: HTTP/HTTPS, TCP, UDP, and file sharing
- **Cross-Platform**: Windows, macOS, Linux, and Raspberry Pi
- **Self-Hostable**: Run your own zrok service instance

## How It Works

`zrok` is built on [Hanzo Zero Trust](https://github.com/hanzoai/ziti), a programmable zero-trust network overlay. This means:

- **No inbound connectivity required**: Works from behind firewalls and NAT
- **End-to-end encryption**: All traffic is encrypted, even from zrok servers
- **Peer-to-peer connections**: Direct connections between users when possible
- **Identity-based access**: Share with specific users, not IP addresses

## Developer SDK

Embed `zrok` sharing into your applications with our Go SDK:

```go
// Create a share
shr, err := sdk.CreateShare(root, &sdk.ShareRequest{
    BackendMode: sdk.TcpTunnelBackendMode,
    ShareMode:   sdk.PrivateShareMode,
})

// Accept connections
listener, err := sdk.NewListener(shr.Token, root)
```

See the [SDK examples](sdk/golang/examples/) for complete examples.

## Self-Hosting

Run your own `zrok` service--from Raspberry Pi to enterprise scale:

- Single binary contains everything you need
- Scales from small personal instances to large public services

[Self-Hosting Guide](docker/compose/zrok-instance/README.md)

## Resources

- **[Building from Source](./BUILD.md)**
- **[Contributing](./CONTRIBUTING.md)**

---

*Ready to start sharing? [Get started with zrok](https://github.com/hanzoai/zrok#quick-start)*
