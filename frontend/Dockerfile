
FROM node:20-slim AS build
WORKDIR /app
COPY . .
RUN echo "⚙️ Simulación de build frontend..." && mkdir -p dist && cp index.html dist/

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
