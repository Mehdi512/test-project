package com.seamless.idm.cockpit.transformer;

import java.util.HashMap;
import java.util.Map;

public class AddRegion implements BaseTransformer {
    @Override
    public Map<String,Object> transformRequest(Map<String, Object> request) {
        return request;
    }

    @Override
    public Map<String,Object> transformResponse(Map<String,Object> response) {
        return response;
    }
}