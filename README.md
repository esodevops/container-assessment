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

Use these steps to deploy the full stack (MongoDB, backend, frontend, ingress) on a local kind cluster.

1. **Install ingress-nginx (one-time per cluster)**

   ```bash
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
   kubectl wait --namespace ingress-nginx \
     --for=condition=ready pod \
     --selector=app.kubernetes.io/component=controller \
     --timeout=120s
   ```

2. **Deploy the application**

   ```bash
   ./scripts/k8s-deploy.sh
   ```

   What this script does:
   - Ensures the `much-todo-cluster` kind cluster exists
   - Waits for the control-plane node to be ready
   - Builds backend and frontend images and loads them into kind
   - Applies Kubernetes manifests under `kubernetes/`

3. **Verify resources**

   ```bash
   kubectl get pods -n much-todo
   kubectl get svc -n much-todo
   kubectl get ingress -n much-todo
   ```

4. **Access the app (Option A: ingress)**

   ```bash
   curl http://localhost
   curl http://localhost/api/health
   ```

   Open in browser:
   - Frontend: http://localhost
   - API health: http://localhost/api/health

5. **Access the app (Option B: port-forward)**

   Run each command in a separate terminal:

   ```bash
   kubectl port-forward svc/frontend-service 8082:80 -n much-todo
   kubectl port-forward svc/backend-service 8080:80 -n much-todo
   ```

   Open in browser:
   - Frontend: http://localhost:8082
   - API health: http://localhost:8080/health

6. **Troubleshooting quick checks**

   ```bash
   kubectl logs deployment/backend -n much-todo --tail=100
   kubectl logs deployment/frontend -n much-todo --tail=100
   kubectl logs deployment/mongodb -n much-todo --tail=100
   ```

7. **Cleanup**

   ```bash
   ./scripts/k8s-cleanup.sh
   kind delete cluster --name much-todo-cluster
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
