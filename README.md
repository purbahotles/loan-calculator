# loan-calculator Hotles Purba (FE)

## Project setup
```
git clone https://github.com/purbahotles/loan-calculator.git
```
```
cd loan-calculator
```

```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

### Compiles and minifies for production
```
npm run build
```

### Lints and fixes files
```
npm run lint
```

# Docker Setup

### Build the Docker image

```
docker-compose build
```


### Start the application with Docker

```
docker-compose up
```


### Stop the Docker containers


```
docker-compose down
```


### View logs from Docker containers


```
docker-compose logs
```



# Versioning Tools Used
```
node version v20.11.0
vue --version @vue/cli 5.0.8
npm --version 10.8.1
npm list vue
loan-calculator@0.1.0
├─┬ @vue/cli-plugin-babel@5.0.8
│ └─┬ @vue/babel-preset-app@5.0.8
│   ├─┬ @vue/babel-preset-jsx@1.4.0
│   │ └── vue@3.4.35 deduped
│   └── vue@3.4.35 deduped
└─┬ vue@3.4.35
  └─┬ @vue/server-renderer@3.4.35
    └── vue@3.4.35 deduped

Docker version 26.0.2
docker-compose version 1.29.2
```

### Access the running application
The application should be accessible at `http://localhost` if running on port 80.

### Troubleshooting
- If you encounter issues with port 80 being in use, ensure no other services are running on this port or change the port mapping in `docker-compose.yml`.


### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).
