# Menggunakan image dasar Node.js
FROM node:18 AS build

# Mengatur direktori kerja di dalam container
WORKDIR /app

# Menyalin file package.json dan package-lock.json ke dalam container
COPY package*.json ./

# Menginstal dependensi aplikasi
RUN npm install

# Menyalin seluruh kode sumber ke dalam container
COPY . .

# Membangun aplikasi
RUN npm run build

# Menggunakan image Nginx untuk menyajikan aplikasi
FROM nginx:alpine

# Menyalin hasil build dari tahap sebelumnya ke direktori Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Mengekspos port Nginx
EXPOSE 80

# Menjalankan Nginx
CMD ["nginx", "-g", "daemon off;"]
