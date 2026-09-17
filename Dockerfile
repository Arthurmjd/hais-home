# 构建阶段
FROM node:22-alpine AS builder
WORKDIR /app

# 安装与 lockfile 版本匹配的 pnpm（lockfileVersion 9 → pnpm 9）
RUN npm install -g pnpm@9

# 先拷贝清单与锁文件，最大化利用构建缓存
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .
# 无 .env 时使用示例配置兜底
RUN [ -e ".env" ] || cp .env.example .env
RUN pnpm build

# 运行阶段：nginx 提供静态资源，gzip_static 直接复用构建期生成的 .gz
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 12445
CMD ["nginx", "-g", "daemon off;"]
