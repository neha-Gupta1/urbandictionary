package main

import (
	"log"
	"net/http"
	"wordsfun/worker"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.LoadHTMLGlob("templates/*")
	router.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"data": "Hello from gin! Yay!"})
	})

	router.GET("/words", func(c *gin.Context) {
		word := c.Query("value")
		ok, res, err := worker.FetchWord(word)
		if err != nil {
			log.Print("error while getting world results")
			return
		}
		if !ok {
			c.JSON(http.StatusBadRequest, gin.H{"message": "pls try again"})
		}
		c.HTML(http.StatusOK, "index.tmpl", gin.H{
			"word": word,
			"data": res,
		})
	})
	router.Run()
}
