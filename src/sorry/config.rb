require "psych"

module Config
    config = Psych.load(File.read "site_config.yml")

    PAGE_INDEX         = config["page_index"]
    PAGE_404           = config["page_404"]
    PAGE_INVALID      = config["page_invalid"]

    TEMPLATE_FOLDER    = config["template_folder"]

    SERVER_PORT        = config["server_port"].to_i
    SERVER_IP          = config["server_ip"]

    CACHE_MODE         = config["cache_mode"]

    TEMP_FOLDER        = config["temp_folder"]
    CACHE_FOLDER       = config["cache_folder"]

    MAX_JOBS           = config['max_jobs']
end