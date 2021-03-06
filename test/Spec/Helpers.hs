module Spec.Helpers where

import Data.ByteString.Char8 (pack)
import Data.Maybe (fromJust)
import Data.Time.Clock (secondsToNominalDiffTime)
import System.Environment (lookupEnv)

import Config (Config(..))
import Config.Mpd (MpdConfig(..))
import Config.Github (GithubConfig(..))
import Config.Weather (WeatherConfig(..))

defaultCfg :: IO Config
defaultCfg = do
    weather <- defaultWeatherCfg
    github  <- defaultGithubCfg
    pure Config
        { weatherCfg = Right weather
        , githubCfg  = Right github
        , mpdCfg     = Right defaultMpdCfg
        }

defaultMpdCfg :: MpdConfig
defaultMpdCfg = MpdConfig
    { mpdEnabled          = True
    , mpdMusicDirectory   = "/home/musicguy/collection"
    , mpdNotifTime        = secondsToNominalDiffTime 10
    , mpdCoverName        = "cover.jpg"
    , mpdSkipMissingCover = True
    }

defaultWeatherCfg :: IO WeatherConfig
defaultWeatherCfg = do
    apiKey <- lookupEnv "OWM_API_KEY"
    pure WeatherConfig
        { weatherEnabled   = True
        , weatherApiKey    = fromJust $ pack <$> apiKey
        , weatherCityId    = "6077243"
        , weatherNotifTime = secondsToNominalDiffTime 10
        , weatherNotifBody = "hullo"
        , weatherSyncFreq  = secondsToNominalDiffTime 1800
        , weatherTemplate  =
            "{{ temp_icon }} {{ temp_celsius }}°C {{ trend }} {{ forecast_icon }} {{ forecast_celcius }}°C" -- Spelling error in celsius on purpose ;/
        }

defaultGithubCfg :: IO GithubConfig
defaultGithubCfg = do
    apiKey <- lookupEnv "GITHUB_TOKEN"
    pure GithubConfig
        { githubEnabled    = True
        , githubApiKey     = fromJust $ pack <$> apiKey
        , githubNotifTime  = secondsToNominalDiffTime 10
        , githubShowAvatar = True
        , githubSyncFreq   = secondsToNominalDiffTime 30
        , githubTemplate   = "{{ notification_count }}"
        , githubAvatarDir  = "/home/someone/.cache/ntfd/github_avatar"
        }
