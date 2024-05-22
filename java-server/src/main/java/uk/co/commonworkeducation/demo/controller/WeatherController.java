package uk.co.commonworkeducation.demo.controller;

import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import uk.co.commonworkeducation.demo.service.WeatherService;

@RestController
public class WeatherController {

    @Autowired
    private WeatherService weatherService;

    @GetMapping("/weather")
    public JsonNode getWeather(@RequestParam String location, @RequestParam String utcHour) {
        return weatherService.getWeatherData(location, utcHour);
    }
}
