require "psych"

module Config
    config = Psych.load(File.read "site_config.yml")

    PAGE_INDEX         = config["page_index"]
    PAGE_404           = config["page_404"]

    TEMPLATE_VIDEO     = config["template_video"]
    TEMPLATE_SUBTITLE  = config["template_subtitle"]
    TEMPLATE_SENTENCES = config["template_sentences"].to_i

    SERVER_PORT        = config["server_port"].to_i
    SERVER_IP          = config["server_ip"]

    CACHE_MODE         = config["cache_mode"]

    TEMP_FOLDER        = config["temp_folder"]
    CACHE_FOLDER       = config["cache_folder"]

    MAX_JOBS           = config['max_jobs']
end