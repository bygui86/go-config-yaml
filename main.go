package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strings"
	"time"

	"gopkg.in/yaml.v2"
)

type Config struct {
	Mode  string   `yaml:"mode"`
	Size  int      `yaml:"size"`
	Debug bool     `yaml:"debug"`
	Items []string `yaml:"items"`
	Log   *Log     `yaml:"log"`
}

type Log struct {
	Level  string `yaml:"level"`
	Format string `yaml:"format"`
}

var (
	config *Config
)

func main() {
	err := loadConfig()
	if err != nil {
		fmt.Println("load config failed: ", err.Error())
		os.Exit(1)
	}

	for {
		fmt.Println(fmt.Sprintf("config: %+v", config))
		time.Sleep(5 * time.Second)
	}
}

func loadConfig() error {
	fmt.Println("load config from ./config.yaml")

	file, fileErr := ioutil.ReadFile("./config.yaml")
	if fileErr != nil {
		return fileErr
	}

	yamlErr := yaml.Unmarshal(file, &config)
	if yamlErr != nil {
		return yamlErr
	}

	return nil
}

func (c *Config) String() string {
	return fmt.Sprintf("Mode=%s, Size=%d, Debug=%t, Items=[ %s ], Log=[ %s ]",
		c.Mode, c.Size, c.Debug, strings.Join(c.Items, ", "), c.Log)
}

func (l *Log) String() string {
	return fmt.Sprintf("Level=%s, Format=%s", l.Level, l.Format)
}
