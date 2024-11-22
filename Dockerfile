FROM python:3.10.1

# Upgrade pip
RUN python -m pip install --upgrade pip
RUN pip install Flask

# Đặt thư mục làm việc trong container
WORKDIR /app

# Sao chép script Python và các file cần thiết vào container
COPY server.py /app/

# Mở cổng cho ứng dụng
EXPOSE 2024

# Lệnh để chạy server
ENTRYPOINT ["python3", "server.py"]
