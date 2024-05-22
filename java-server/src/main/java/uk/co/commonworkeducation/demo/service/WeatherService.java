package uk.co.commonworkeducation.demo.service;

import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class WeatherService {

    private final RestTemplate restTemplate;

    @Value("${geonames.username}")
    private String geonamesUsername;

    public WeatherService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public JsonNode getWeatherData(String location, String utcHour) {
        String encodedLocation = java.net.URLEncoder.encode(location, java.nio.charset.StandardCharsets.UTF_8);
        String geoSearchUrl = String.format("http://api.geonames.org/searchJSON?q=%s&maxRows=3&username=%s", encodedLocation, geonamesUsername);
        JsonNode geoResponse = restTemplate.getForObject(geoSearchUrl, JsonNode.class);

        JsonNode geoname = geoResponse.get("geonames").get(0);
        String geonameId = geoname.get("geonameId").asText();
        String geoDetailsUrl = String.format("http://api.geonames.org/getJSON?geonameId=%s&username=%s", geonameId, geonamesUsername);
        JsonNode geoDetailsResponse = restTemplate.getForObject(geoDetailsUrl, JsonNode.class);

        double latitude = geoDetailsResponse.get("lat").asDouble();
        double longitude = geoDetailsResponse.get("lng").asDouble();
        int altitude = geoDetailsResponse.get("srtm3").asInt();

        String weatherUrl = String.format("https://api.met.no/weatherapi/locationforecast/2.0/compact?altitude=%d&lat=%.4f&lon=%.4f", altitude, latitude, longitude);
        JsonNode weatherResponse = restTemplate.getForObject(weatherUrl, JsonNode.class);

        return weatherResponse;
    }
}
