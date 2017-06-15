This role is for a client host which pushes data to the ElasticSearch / LogStash / Kibana (ELK) Stack.

This role is characterized primarily by:
- Installation of an SSL Cert used for communication with the ELK Server.
- Installation, configuration and running the 'filebeat' service, which forwards selected log files to LogStash.

Defaults are provided for the environment (dev),  logs to capture, and ELK Server. See defaults/main.yml. Override as necessary.

See https://confluence.cablevision.com/display/EITA/Reference+Architecture+-+Log+Monitoring+with+Open+Source for an overview of how to use the ELK stack.
