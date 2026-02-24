def get_element_by_resource_id(resource_id):
    return f"xpath=//*[contains(@resource-id,'{resource_id}')]"

def get_element_by_id(element_id):
    return f"id=com.saucelabs.mydemoapp.android:id/{element_id}"

def get_element_by_text(text):
    return f"xpath=//*[@text='{text}']"