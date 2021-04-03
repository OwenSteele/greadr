package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"

	//"path/filepath"
	"strings"
)

type GConfig struct {
	Ignore struct {
		Folders    []string
		FileTypes  []string
		Partials   []string
		FileNames  []string
		OutputFile bool
	}
	Output struct {
		Name string
		Type string
	}
	Format struct {
		FileTitle   string
		DoubleSpace bool
		IgnoreEmpty bool
		Append      bool
	}
	Text struct {
		Before string
		After  string
	}
}

var data GConfig

func main() {

	args := os.Args[1:]
	var argOne string

	if len(args) > 0 {
		argOne = args[0]
	}

	getJson(argOne)

	fileName := getParentPath()

	if _, err := os.Stat(fileName); os.IsNotExist(err) {

		fileNameLower := strings.ToLower(fileName)

		if _, err := os.Stat(fileNameLower); os.IsNotExist(err) {

			fmt.Println("!!!Error could not find a readme markdown file - creating...")

			createFile(fileName)

		} else {
			fileName = fileNameLower
		}
	}

	fmt.Print("	Comparing dir trees ")

	cmdStr := "tree /a /f >" + fileName
	c := exec.Command("cmd", "/C", cmdStr)
	if err := c.Run(); err != nil {
		fmt.Println("!!!Error: ", err)
		os.Exit(1)
	}

	fmt.Print(".")

	input, err := ioutil.ReadFile(fileName)
	if err != nil {
		fmt.Println("!!!Error: ", err)
		os.Exit(1)
	}

	fmt.Print(".")

	lines := strings.Split(string(input), "\n")

	fmt.Print(". ")

	output := removeLines(lines)

	fmt.Println("	Writing updates.")

	if strings.ToLower(data.Output.Type) == "md" {
		output = "\n# " + data.Format.FileTitle + "\n\n### Created with **greadr**\nhttps://github.com/OwenSteele/greadr\n<pre>" + output + "\n</pre>\n"
	} else {
		output = "\n   ----- " + data.Format.FileTitle + " -----   \n\n --- Created with greadr ---\nhttps://github.com/OwenSteele/greadr\n\n" + output + "\n\n"
	}

	output = data.Text.Before + output + data.Text.After

	//if data.Format.Append {
	//headerfooter := "<|---------------------------------------------|>"

	//output = headerfooter + output + headerfooter
	// if pos < 0 {
	// 	fileOpen, errOpen := os.OpenFile(fileName, os.O_APPEND, 0644)
	// 	if errOpen != nil {
	// 		fmt.Println("!!!Error could not open file to append")
	// 	}
	// 	defer fileOpen.Close()
	// 	if _, errOpen := fileOpen.WriteString(output); errOpen != nil {
	// 		fmt.Println("!!!Error could not append to file")
	// 	}
	// } else {
	// 	before := string([]rune(existingText)[:pos])
	// 	fmt.Println("before:" + before) ///////////////////////////
	// 	after := string([]rune(existingText)[posEnd:])
	// 	fmt.Println("after:" + after) ///////////////////////////
	// 	output = before + output + after
	// 	fmt.Println("output:" + output) ///////////////////////////
	// 	errWrite := ioutil.WriteFile(fileName, []byte(output), 0644)
	// 	if errWrite != nil {
	// 		fmt.Println("!!!Error could not edit readme markdown file")
	// 		os.Exit(1)
	// 	}
	// }
	// } else {
	errWrite := ioutil.WriteFile(fileName, []byte(output), 0644)
	if errWrite != nil {
		fmt.Println("!!!Error could not edit readme markdown file")
		os.Exit(1)
	}
	//}

	fmt.Println("--> git readme file formatted.")
}

func removeLines(lines []string) string {
	//lines 0,1 are drive info
	for i := 0; i < 2; i++ {
		lines[i] = ""
	}

	lines[2] = "ROOT"
	output := ""
	linesRemoved := 0

	for i := 3; i < len(lines); i++ {

		ignoreLine := false

		if isEmptyLine(lines[i]) {
			linesRemoved++
			continue
		}

		if strings.Contains(lines[i], fmt.Sprintf("%s.%s", data.Output.Name, data.Output.Type)) && data.Ignore.OutputFile {
			linesRemoved++
			continue
		}

		for _, fileType := range data.Ignore.FileTypes {
			if strings.Contains(strings.ToLower(lines[i]), fmt.Sprintf("%s%s", ".", fileType)) {
				ignoreLine = true
				linesRemoved++
				break
			}

		}

		for _, partial := range data.Ignore.Partials {
			if strings.Contains(strings.ToLower(lines[i]), partial) {
				ignoreLine = true
				linesRemoved++
				break
			}
		}

		for _, fileName := range data.Ignore.FileNames {
			if strings.Contains(strings.ToLower(lines[i]), fileName) {
				ignoreLine = true
				linesRemoved++
				break
			}
		}
		if ignoreLine {
			continue
		}

		if strings.ToLower(data.Output.Type) == "md" {
			lines[i] = "<br>" + lines[i]
		}

		output += lines[i] + "\n"
	}
	fmt.Printf("	Removed %v lines. ", linesRemoved)

	return output
}

func createFile(targetPath string) {

	err := ioutil.WriteFile(targetPath, []byte(""), 0755)
	if err != nil {
		fmt.Printf("!!!Unable to write file: %v", err)
		os.Exit(1)
	}
}

func getParentPath() string {

	currPath, errDir := os.Getwd()
	if errDir != nil {
		fmt.Printf("!!!Internal Dir error occured. %v", errDir)
		os.Exit(1)
	}

	//result := filepath.Dir(currPath) + "\\" + data.Output.Name + "." + data.Output.Type
	result := currPath + "\\" + data.Output.Name + "." + data.Output.Type

	return result
}

func isEmptyLine(line string) bool {

	if (len(line) == 0 || line == "") && data.Format.IgnoreEmpty {
		return true
	}

	if data.Format.DoubleSpace {
		return false
	}

	result := strings.ReplaceAll(line, " ", "")
	result2 := strings.ReplaceAll(result, "|", "")
	result3 := strings.TrimSpace(result2)

	if len(result3) == 0 || result3 == "" {
		return true
	}

	return false
}

func getJson(location string) {

	var bytes []byte

	if len(location) == 0 || location == "" {
		fmt.Println("	Checking greadr config")
		//file, err := ioutil.ReadFile("greadr.json")
		file, err := ioutil.ReadFile("greadr.json")
		if err != nil {
			fmt.Println("!!!greadr.json could not be found, please check it is in the greadr folder. (OR use a template)")
			os.Exit(1)
		}
		bytes = []byte(file)
	} else {
		fmt.Println("	Using Template")
		file, err := ioutil.ReadFile(location)
		if err != nil {
			fmt.Println("!!!the requested template json could not be found, please check it is in the root templates folder.")
			os.Exit(1)
		}
		bytes = []byte(file)
	}

	err2 := json.Unmarshal(bytes, &data)
	if err2 != nil {
		fmt.Printf("!!!Formatting error with JSON config file  %v", err2)
		os.Exit(1)
	}

	nilErr := ""

	if data.Output.Name == "" {
		nilErr += "output -> name "
	}
	if data.Output.Type == "" {
		nilErr += "output -> type "
	}

	if nilErr != "" {
		fmt.Printf("!!!greadr.json error, required fields missing: '%s'", nilErr)
		os.Exit(1)
	}
}
