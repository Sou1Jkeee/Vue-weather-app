<template>
  <div class="row">
    <div class="col-md">
      <h3 class="text-success">{{ title }}</h3>
      <!-- <p v-if="error">{{ error.message }}</p> -->
      <div class="card bg-dark text-white rounded-3">
        <img :src="getImageUrl('n.jpg')" class="card-img-top weather-background" alt="weather-image">
        <div class="card-img-overlay">
          <form v-show="!!cities">
            <div class="form-floating mb-4">
              <select  v-model="selectedCity" @change="getWeather()" id="selectedCity" class="form-select border-2 text-white py-0 border-success bg-transparent">
                <option v-for="(city) of cities" :key="city" :value="city">{{ city }}</option>
              </select>
            </div>
          </form>
          <h5 class="card-title text-center"> {{ selectedCity }}</h5>
          <div class="card-body">
            <div v-if="weatherData" class="text-center">
              <div class="row">
                <div class="col">
                  <img :src="getImageUrl('temp.png')" alt="temp-icon" class='weather-icon'/>
                  <span class="fs-3"> {{ weatherData.temp }}&deg;</span>
                  <p class="card-xs-text">ощущается как {{ weatherData.feels_like }}&deg;</p>
                </div>
                <div class="col">
                  <img :src="getImageUrl('temp_min.png')" alt="temp-min-icon" class='weather-icon'/>
                  <img :src="getImageUrl('temp_max.png')" alt="temp-max-icon" class='weather-icon'/>
                  <p class="card-sm-text">{{ weatherData.temp_min }}...{{ weatherData.temp_max }} C&deg;</p>
                </div>
              </div>
              <div class="row">
                <div class="col">
                  <img :src="getImageUrl(`${weatherData.icon || 'clouds'}.png`)" alt="weather-icon" class='weather-icon'/>
                  <p class="card-sm-text">{{ weatherData.description }}</p>
                </div>
                <div class="col">
                  <img :src="getImageUrl('clouds_all.png')" alt="clouds_all-icon" class='weather-icon'/>
                  <p class="card-sm-text">{{ weatherData.clouds_all }}&percnt;</p>
                </div>
              </div>
              <div class="row">
                <div class="col">
                  <img :src="getImageUrl('wind.png')" alt="wind-icon" class='weather-icon'/>
                  <p class="card-sm-text">{{ weatherData.wind_speed }} м/c</p>
                </div>
                <div class="col">
                  <img :src="getImageUrl('humidity.png')" alt="humidity-icon" class='weather-icon'/>
                  <p class="card-sm-text">{{ weatherData.humidity }}&percnt;</p>
                </div>
              </div>
              <div class="row">
                <div class="col">
                  <img :src="getImageUrl('sunrise.png')" alt="sunset-icon" class='weather-icon'/>
                  <p class="card-sm-text">{{ weatherData.sunrise }}</p>
                </div>
                <div class="col">
                  <img :src="getImageUrl('sunset.png')" alt="sunset-icon" class='weather-icon'/>
                  <p class="card-sm-text">{{ weatherData.sunset }}</p>
                </div>
              </div>
              <div class="row">
                <div class="col">
                  <img :src="getImageUrl('pressure.png')" alt="humidity-icon" class='weather-icon'/>
                  <p class="card-sm-text">{{ weatherData.pressure }} мм рт. ст.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';


export default {
  name: 'AppWeather',
  props: {
    title: String
  },
  data: () => ({
    jsonData: [],
    weatherData: {},
    cities: null,
    defaultParams: { lat: 55.7483, lon: 37.6171, units: 'metric', lang: 'ru', appid: import.meta.env.VITE_APP_API_KEY },
    selectedCity: localStorage?.weatherCity || 'Москва',
    error: null
  }),

  methods: {
    getImageUrl(path) {
      return new URL(`../assets/${path}`, import.meta.url).href;
    },

    setCity(city) {
      localStorage.weatherCity = city;
    },

    getWeather() {
      const params = this.defaultParams

      if (this.jsonData[this.selectedCity]?.lat && this.jsonData[this.selectedCity]?.lon) {
        params.lat = this.jsonData[this.selectedCity].lat,
        params.lon = this.jsonData[this.selectedCity].lon
      }

      this.setCity(this.selectedCity)

      axios.get('https://api.openweathermap.org/data/2.5/weather', {
        params: params
      })
      .then(response => {
        const data = response.data
        this.weatherData.description  = data.weather[0].description
        this.weatherData.icon         = data.weather[0].main.toLowerCase()
        this.weatherData.temp         = Math.ceil(data.main.temp)
        this.weatherData.feels_like   = Math.round(data.main.feels_like)
        this.weatherData.temp_min     = Math.floor(data.main.temp_min)
        this.weatherData.temp_max     = Math.ceil(data.main.temp_max)
        this.weatherData.pressure     = (data.main.pressure * 0.738).toFixed(2)
        this.weatherData.humidity     = data.main.humidity
        this.weatherData.visibility   = data.visibility
        this.weatherData.wind_speed   = data.wind.speed
        this.weatherData.clouds_all   = data.clouds.all
        this.weatherData.sunrise      = this.getTime(data.sys.sunrise)
        this.weatherData.sunset       = this.getTime(data.sys.sunset)
      })
      .catch(err => this.error = err)
    },

    fetchCities() {
      fetch('cities.json')
      .then(res => res.json())
      .then(data => {
        this.jsonData = data
        this.cities = Object.keys(data).sort()
      })
      .catch(err => this.errors = err)
    },

    getTime(timestamp) {
      return new Intl.DateTimeFormat('ru-RU', { hour: 'numeric', minute: 'numeric' }).format(new Date(timestamp * 1000))
    }
  },

  mounted() {
    this.fetchCities()
    this.getWeather()
  }
}
</script>

<style scoped>
  select option {
    background-color: #1a2831 !important;
  }

  .weather-background {
    width: 20rem;
  }

  .weather-icon {
    width: 2.8rem;
  }

  .card-sm-text {
    font-size: .8rem;
  }

  .card-xs-text {
    font-size: .6rem;
  }
</style>
