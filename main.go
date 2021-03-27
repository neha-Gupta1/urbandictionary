package main

import (
	"log"
	"net/http"
	"wordsfun/worker"

	"github.com/gin-gonic/contrib/static"
	"github.com/gin-gonic/gin"
)

type Result struct {
	Word       string `json:"word" binding:"required"`
	Definition string `json:"definition" binding:"required"`
}

func main() {
	router := gin.Default()
	router.Use(static.Serve("/", static.LocalFile("./views", true)))
	// router.LoadHTMLGlob("views/index.tmpl")
	// router.GET("/go", func(c *gin.Context) {
	// 	c.JSON(http.StatusOK, gin.H{"data": "Hello from gin! Yay!"})
	// })

	api := router.Group("/api")
	{
		api.GET("/", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{
				"message": "pong",
			})
		})
		api.GET("/words", func(c *gin.Context) {
			c.Header("Content-Type", "application/json")
			word := c.Query("value")
			ok, res, err := worker.FetchWord(word)
			if err != nil {
				log.Print("error while getting world results")
				return
			}
			if !ok {
				c.JSON(http.StatusBadRequest, gin.H{"message": "pls try again"})
			}
			result := Result{
				Word:       word,
				Definition: res,
			}
			c.JSON(http.StatusOK, result)
		})
	}

	router.Run()
}
