FROM ruby:2.5
RUN useradd -r garufa -u 751 && gem install garufa
USER garufa:garufa
EXPOSE ${port:-8000}
ENTRYPOINT \
  garufa --environment ${environment:-development} \
         --port ${port:-8000} \
         --app_id ${pusher_app_id} \
         --app_key ${pusher_app_key} \
         --secret ${pusher_secret} \
         ${log:+--log} ${log:---stdout} \
         --verbose
