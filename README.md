# 🏡🖥️ Mars Server

Managed home server with Docker, Docker Compose, Make and Bash.

## 🧩 Requirements

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)
- Make
- [fzf](https://github.com/junegunn/fzf)

## 🧑‍🍳 Configuration

Before deploying the services it is necessary to configure them. To do so, it is enough to create an .env file for each service with the content of the corresponding .env.template.

## 🏗️ Installation

```bash
server.sh install
```

## 🧙 Usage

```bash
Usage: server [OPTIONS] COMMAND

This script aims to manage a home server based on Docker, Docker Compose, Make and Bash.

Available options:
  -h, --help      Print this help and exit

Available commands:
  install         Install all services
  uninstall       Uninstall all services
  start           Start all services
  stop            Stop all services
  restart         Restart all services
  status          Get the status of all services
  services        Open a menu based on FZF to manage the services separately
```

## 🎯 Credits

To realise this project I have based myself on many similar projects. There were countless of them and I gave them all a star.

🙏 Thank you very much for these wonderful creations.

### ⭐ Stargazers

[![Stargazers repo roster for @borjapazr/mars-server](https://reporoster.com/stars/borjapazr/mars-server)](https://github.com/borjapazr/mars-server/stargazers)

## ⚖️ License

The MIT License (MIT). Please see [License](LICENSE) for more information.
