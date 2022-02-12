package env

import (
	"github.com/kelseyhightower/envconfig"
)

type Environments struct {
	GoEnv            string `envconfig:"GO_ENV"`
	AWSAccessID      string `envconfig:"ACCESS_ID"`
	AWSSecretKey     string `envconfig:"SECRET_KEY"`
	AWSS3URL         string `envconfig:"S3_URL"`
	AWSCloudfrontURL string `envconfig:"CLOUDFRONT_URL"`
	DBUser           string `envconfig:"DB_USER"`
	DBPassword       string `envconfig:"DB_PASSWORD"`
	DBHost           string `envconfig:"DB_HOST"`
	DBName           string `envconfig:"DB_NAME"`
	DBPort           string `envconfig:"DB_PORT"`
}

var env Environments
var alreadySet = false

func Get() Environments {
	if !alreadySet {
		set()
	}
	return env
}

func set() {
	if err := envconfig.Process("", &env); err != nil {
		panic(err.Error())
	}
	alreadySet = true
}
