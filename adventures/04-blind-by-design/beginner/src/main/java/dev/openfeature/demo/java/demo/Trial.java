package dev.openfeature.demo.java.demo;

import dev.openfeature.sdk.Client;
import dev.openfeature.sdk.FlagEvaluationDetails;
import dev.openfeature.sdk.OpenFeatureAPI;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Trial {

    private final Client client = OpenFeatureAPI.getInstance().getClient();

    @GetMapping("/")
    public FlagEvaluationDetails<String> observeSubject() {
        return client.getStringDetails("vision_state", "untreated");
    }
}
