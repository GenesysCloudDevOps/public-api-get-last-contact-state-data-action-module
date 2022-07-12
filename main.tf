resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "CONVERSATION_ID" = {
                "type" = "string"
            }
        },
        "type" = "object"
    })
    contract_output = jsonencode({
        "additionalProperties" = true,
        "properties" = {
            "WRAP_UP_NAME" = {
                "type" = "string"
            },
            "WRAP_UP_TIME" = {
                "type" = "string"
            }
        },
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/conversations/$${input.CONVERSATION_ID}"
    }

    config_response {
        success_template = "{ \"convEnd\": $${convEnd} }"
        translation_map = { 
            WRAP_UP_NAME = "$.participants[?(@.purpose == 'agent')].wrapup.name",
            WRAP_UP_TIME = "$.participants[?(@.purpose == 'agent')].wrapup.endTime"
        }
    }
}