FROM ruby:2.5-slim

WORKDIR /build

COPY . .

RUN useradd -r garufa -u 751 \
 && apt-get update \
 && apt-get install -y build-essential \
 && gem build garufa.gemspec -o garufa.gem \
 && gem install ./garufa.gem \
 && apt-get purge -y --auto-remove build-essential \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/

EXPOSE ${port:-8000}

USER garufa:garufa
ENTRYPOINT garufa \
    --environment ${environment:-development} \
    --port ${port:-8000} \
    --app_id ${pusher_app_id} \
    --app_key ${pusher_app_key} \
    --secret ${pusher_secret} \
    ${log:+--log} ${log:---stdout} \
    ${extra_args}
