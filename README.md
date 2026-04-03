# Much To Do

A full-stack todo application built with modern web technologies. Features user authentication, todo management, and a clean, responsive UI.

## Features

- **User Authentication**: Register, login, and manage user accounts with JWT tokens
- **Todo Management**: Create, read, update, and delete todos
- **Responsive UI**: Modern React frontend with Tailwind CSS and Radix UI components
- **RESTful API**: Go backend with Gin framework and comprehensive API documentation
- **Database**: MongoDB for data persistence
- **Caching**: Redis for session management and caching
- **Containerization**: Docker support for easy deployment
- **Kubernetes**: Production-ready deployment manifests

## Tech Stack

### Frontend

- **React 19** - UI framework
- **TypeScript** - Type safety
- **Vite** - Build tool and dev server
- **TanStack Router** - Client-side routing
- **TanStack Query** - Data fetching and caching
- **Tailwind CSS** - Styling
- **Radix UI** - Accessible UI components
- **React Hook Form** - Form handling
- **Zod** - Schema validation

### Backend

- **Go 1.25** - Programming language
- **Gin** - HTTP web framework
- **MongoDB** - NoSQL database
- **Redis** - Caching and sessions
- **JWT** - Authentication tokens
- **Swagger** - API documentation

### DevOps

- **Docker** - Containerization
- **Docker Compose** - Local development
- **Kubernetes** - Container orchestration
- **Kind** - Local Kubernetes cluster
- **NGINX Ingress** - Load balancing and routing

## Prerequisites

- **Docker** and **Docker Compose** (for local development)
- **Go 1.25+** (for backend development)
- **Node.js 18+** and **npm** (for frontend development)
- **kubectl** and **kind** (for Kubernetes deployment)
- **MongoDB** (optional, can use Docker)

## Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd much-to-do
   ```

2. **Backend dependencies**

   ```bash
   cd Server/MuchToDo
   go mod download
   ```

3. **Frontend dependencies**
   ```bash
   cd Client
   npm install
   ```

## Running Locally

### Using Docker Compose (Recommended)

1. **Start all services**

   ```bash
   make dc-up
   # or
   docker-compose up --build
   ```

2. **Access the application**
   - Frontend: kubectl port-forward svc/frontend-service 8082:80 -n much-todo
   - Backend API: kubectl port-forward svc/backend-service 8081:80 -n much-todo
   - API Documentation: http://localhost:8080/swagger/index.html

### Manual Development Setup

1. **Start MongoDB and Redis**

   ```bash
   docker-compose up mongodb redis
   ```

2. **Start Backend**

   ```bash
   cd Server/MuchToDo
   go run cmd/api/main.go
   ```

3. **Start Frontend**

   ```bash
   cd Client
   npm run dev
   ```

4. **Access the application**
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:8080
   - API Documentation: http://localhost:8080/swagger/index.html

## Kubernetes Deployment

1. **Create Kind cluster**

   ```bash
   kind create cluster --name much-to-do-cluster --config kind-config.yaml
   ```

2. **Deploy application**

   ```bash
   ./scripts/k8s-deploy.sh
   ```

3. **Access the application**
   - Application: http://localhost
   - API endpoints: http://localhost/api/\*
   - API Documentation: http://localhost/api/swagger/index.html

4. **Check deployment status**
   ```bash
   kubectl get all -n much-todo
   ```

## Testing

### Backend Tests

```bash
cd Server/MuchToDo
go test ./...
```

### Frontend Tests

```bash
cd Client
npm run test
```

