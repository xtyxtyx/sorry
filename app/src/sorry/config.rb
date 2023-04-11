require "yaml"

module Config
    config = YAML.load(File.read "site_config.yml")

    PAGE_404           = config["page_404"]
    PAGE_INVALID       = config["page_invalid"]

    SERVER_PORT        = config["server_port"].to_i
    SERVER_IP          = config["server_ip"]

    MAX_JOBS           = config['max_jobs']

    FFMPEG_COMMAND     = config['ffmpeg_command']
end