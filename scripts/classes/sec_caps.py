SEC_CAPS_CLOUD 	= ['access_logs', 'authentication', 'host_ids', 'process_isolation', 'permission_model', 'resource_monitoring', 'restore_point', 'user_data_isolation', # virtualisation
                'certificates', 'firewall', 'enc_iot', 'node_isolation', 'network_ids', 'public_key_crypto', # communications
                'backup', 'enc_storage', # data
                'access_control', 'anti-tampering', # physical
                'audit'] # others

SEC_CAPS_EDGE 	= ['access_logs', 'authentication', 'host_ids', 'process_isolation', 'permission_model', 'resource_monitoring', 'user_data_isolation', # virtualisation
                'certificates', 'firewall', 'enc_iot', 'node_isolation', 'network_ids', 'public_key_crypto', # communications
                'backup', 'enc_storage', # data,
                'access_control', 'anti-tampering', # physical
                'audit'] # others

SEC_CAPS_IOT 	= ['authentication', 'resource_monitoring', # virtualisation
                'firewall', 'enc_iot', 'node_isolation', 'public_key_crypto', 'wireless_security' # communications
                'enc_storage', 'obfuscated_storage', # data,
                'anti-tampering'] # physical
                # others