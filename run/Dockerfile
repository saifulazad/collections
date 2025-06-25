# Copyright 2020 Google, LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START cloudrun_helloworld_dockerfile]
# [START run_helloworld_dockerfile]

# Use the official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.11-slim

ENV APP_HOME /app
WORKDIR $APP_HOME

# Install necessary system dependencies
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0

# Copy requirement file
COPY requirements.txt .

# Install production dependencies.
RUN pip install --no-cache-dir -r requirements.txt

# Copy all files
COPY . .


ENV PORT=8080
EXPOSE $PORT

# Your CMD should use the PORT environment variable
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app