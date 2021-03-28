package worker

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"wordsfun/models"
)

func FetchWord(word string) (ok bool, bod []models.WordResult, err error) {
	url := "https://mashape-community-urban-dictionary.p.rapidapi.com/define?term=" + fmt.Sprintf("%s", word)

	req, _ := http.NewRequest("GET", url, nil)

	req.Header.Add("x-rapidapi-key", "c00a03fa2dmsh6bd2d46a085b6bap1cbcaejsn2db4322306d3")
	req.Header.Add("x-rapidapi-host", "mashape-community-urban-dictionary.p.rapidapi.com")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Print("error while fetching work pls try again :: ", err)
		return false, nil, err
	}

	defer res.Body.Close()
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		log.Print("error while reading response body try again :: ", err)
		return false, nil, err
	}
	var words map[string][]models.WordResult
	fmt.Println(string(body))
	r := bytes.NewReader(body)

	dec := json.NewDecoder(r)

	if err = dec.Decode(&words); err != nil {
		log.Print("error while converting to common model")
		return false, nil, err
	}

	// ac, mok := words["list"].([]map[string]string)
	// if !mok {
	// 	log.Print("error while conversion")
	// 	return false, "", errors.New("error in conversion")
	// }

	list := words["list"]

	// log.Print("-----------------------------------")
	// log.Println("the definition is :: ", list[0].Definition)
	// log.Println(list[1].Definition)
	// log.Print("-----------------------------------")
	return true, list, nil
}
