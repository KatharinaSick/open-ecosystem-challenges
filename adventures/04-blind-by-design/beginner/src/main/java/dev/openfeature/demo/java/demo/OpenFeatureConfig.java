package dev.openfeature.demo.java.demo;

import dev.openfeature.contrib.providers.flagd.Config;
import dev.openfeature.contrib.providers.flagd.FlagdOptions;
import dev.openfeature.contrib.providers.flagd.FlagdProvider;
import dev.openfeature.sdk.OpenFeatureAPI;
import jakarta.annotation.PostConstruct;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenFeatureConfig {

    @PostConstruct
    void configureOpenFeature() {
        FlagdOptions options = FlagdOptions.builder()
                .resolverType(Config.Resolver.RPC)
                .build();

        OpenFeatureAPI.getInstance().setProvider(new FlagdProvider(options));
    }
}