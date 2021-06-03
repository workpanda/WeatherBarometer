import csv
import json
import logging
import pymongo
from pymongo.collection import Collection
import requests


logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
stream_handler = logging.StreamHandler()
stream_handler.setLevel(logging.DEBUG)
logger.addHandler(stream_handler)


class Location(object):
    def __init__(self, latitude: float, longitude: float):
        self.latitude = latitude
        self.longitude = longitude

    def __str__(self):
        return "{:.2f}, {:.2f}".format(self.latitude, self.longitude)


class LocationsLoader1(object):
    def __init__(self, path: str):
        self.path = path

    def load_locations(self) -> [Location]:
        locations = []
        with open(self.path, 'r') as csvfile:
            reader = csv.reader(csvfile, delimiter='\t', quotechar='"')
            for row in reader:
                try:
                    locations.append(Location(float(row[0]), float(row[1])))
                except Exception:
                    pass

        return locations


class LocationsLoader2(object):
    def __init__(self, path: str):
        self.path = path

    def load_locations(self) -> [Location]:
        locations = []
        data_items = json.loads(open(self.path, 'r').read())
        for item in data_items:
            latlng = item['latlng']
            if len(latlng) > 0:
                location = Location(latlng[0], latlng[1])
                locations.append(location)

        return locations


class WeatherIconsCrawler(object):
    def __init__(self, target_collection: Collection, locations: [Location]):
        self.target_collection = target_collection
        self.locations = locations

    def get_weather(self):
        url_params = {"api": "00728e87-7005-4043-9050-c84d5e7d8ca6"}
        for i, location in enumerate(self.locations):
            if 0 == i % 10:
                logger.info('Processed {} from {} documents'.format(i, len(self.locations)))
            request_url = "http://dsx.weather.com/wxd/v2/MORecord/en_DE/{:.2f},{:.2f}".format(location.latitude,
                                                                                              location.longitude)
            response = requests.get(request_url, params=url_params)
            try:
                data = response.json()
            except Exception:
                continue
            weather_data = data['MOData']
            self.target_collection.insert(weather_data)

    def get_forecasts(self):
        url_params = {"api": "00728e87-7005-4043-9050-c84d5e7d8ca6"}
        for i, location in enumerate(self.locations):
            if 0 == i % 10:
                logger.info('Processed {} from {} documents'.format(i, len(self.locations)))
            request_url = "http://dsx.weather.com/wxd/v3/DFRecord/en_DE/{:.2f},{:.2f}".format(location.latitude,
                                                                                              location.longitude)
            response = requests.get(request_url, params=url_params)
            try:
                data = response.json()
            except Exception:
                continue
            weather_data = data['DFData']
            self.target_collection.insert(weather_data)

    def aggregate_results(self):
        results = self.target_collection.aggregate([{'$group': {'_id': {'name': "$wx"}}}])['result']
        for result in results:
            name = result['_id'].get('name')
            if name:
                logger.info("{}".format(name))

    def aggregate_forecasts(self):
        results = self.target_collection.aggregate([{'$group': {'_id': {'name': "$snsblWx12_24"}}}])['result']
        for result in results:
            name = result['_id'].get('name')
            if name:
                logger.info("{}".format(name))


if __name__ == "__main__":
    conn = pymongo.MongoClient('localhost')
    db_source = conn.barometer_pro

    # location_items = LocationsLoader1('data/locations.csv').load_locations()
    location_items = LocationsLoader2('data/countries.json').load_locations()

    crawler = WeatherIconsCrawler(db_source['forecasts'], location_items)
    # crawler.get_weather()
    # crawler.get_forecasts()
    # crawler.aggregate_results()
    crawler.aggregate_forecasts()