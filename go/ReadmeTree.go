package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"strings"
	//"path/filepath"
)

type GConfig struct {
	Ignore struct {
		Folders     []string
		FileTypes   []string
		Partials    []string
		FileNames   []string
		OutputFile  bool
		GreadrFiles bool
		GitFiles    bool
	}
	Output struct {
		Name string
		Type string
	}
	Format struct {
		FileTitle   string
		DoubleSpace bool
		IgnoreEmpty bool
	}
	Data struct {
		Before struct {
			Text     string
			FilePath string
		}
		After struct {
			Text     string
			FilePath string
		}
	}
}

var data GConfig

func main() {

	xxxx := getFolderCount("| | | kjlkj |")

	fmt.Print(xxxx)

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

			fmt.Println("	Could not find a readme markdown file - creating...")

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

	fmt.Println("---Writing updates.")

	if strings.ToLower(data.Output.Type) == "md" {
		output = "\n# " + data.Format.FileTitle + "\n\n### Created with **greadr**(https://github.com/OwenSteele/greadr)\n<pre>" + output + "\n</pre>\n"
	} else {
		output = "\n   ----- " + data.Format.FileTitle + " -----   \n\n --- Created with greadr --- (https://github.com/OwenSteele/greadr)\n\n" + output + "\n\n"
	}

	beforeFileText := getExistingFileContent(data.Data.Before.FilePath)
	afterFileText := getExistingFileContent(data.Data.After.FilePath)

	if len(beforeFileText) != 0 || beforeFileText != "" {
		beforeFileText += "\n"
	}
	if len(afterFileText) != 0 || afterFileText != "" {
		afterFileText = "\n" + afterFileText
	}
	if len(data.Data.Before.Text) != 0 || data.Data.Before.Text != "" {
		data.Data.Before.Text += "\n"
	}
	if len(data.Data.After.Text) != 0 || data.Data.After.Text != "" {
		data.Data.After.Text = "\n" + data.Data.After.Text
	}

	output = strings.Trim(beforeFileText+data.Data.Before.Text+output+data.Data.After.Text+afterFileText, " ")
	output = strings.Trim(output, "\n")

	errWrite := ioutil.WriteFile(fileName, []byte(output), 0644)
	if errWrite != nil {
		fmt.Println("!!!Error could not edit readme markdown file")
		os.Exit(1)
	}

	fmt.Println("--> git readme file formatted.")
}

func getExistingFileContent(path string) string {
	if len(path) == 0 || path == "" {
		return ""
	}

	file, err := ioutil.ReadFile(fmt.Sprintf("greadr/%v", path))
	if err != nil {
		fmt.Printf("	! '%v' could not be found, ensure it is in the local greadr subfolder\n", path)
		return ""
	}
	return string(file)
}

func removeLines(lines []string) string {

	output := "ROOT_FOLDER\n"
	linesRemoved := 0
	// lines 1-3 are personal drive info
	ignoreFolderLock := false
	//subDirCount := 0
	for i := 3; i < len(lines); i++ {

		ignoreLine := false

		if ignoreFolderLock {
			if strings.Contains(strings.ToLower(lines[i]), "+---") || strings.Contains(strings.ToLower(lines[i]), "\"---") || isEmptyLine(lines[i]) {
				ignoreFolderLock = false
			} else {
				linesRemoved++
				continue
			}
		}

		for _, folder := range data.Ignore.Folders {
			if strings.Contains(strings.ToLower(lines[i]), fmt.Sprintf("---%s", folder)) {
				ignoreFolderLock = true
				ignoreLine = true
				break
			}
		}
		if isEmptyLine(lines[i]) || strings.Contains(lines[i], "No subfolders exist") {
			linesRemoved++
			continue
		} else if strings.Contains(lines[i], fmt.Sprintf("%s.%s", data.Output.Name, data.Output.Type)) && data.Ignore.OutputFile {
			linesRemoved++
			continue
		}
		if data.Ignore.GreadrFiles {
			if strings.Contains(strings.ToLower(lines[i]), "greadr.json") {
				linesRemoved++
				continue
			} else if strings.Contains(strings.ToLower(lines[i]), fmt.Sprintf("---greadr")) {
				ignoreFolderLock = true
				linesRemoved++
				continue
			}
		}
		if data.Ignore.GitFiles {
			if strings.Contains(strings.ToLower(lines[i]), ".gitignore") {
				linesRemoved++
				continue
			} else if strings.Contains(strings.ToLower(lines[i]), ".gitattributes") {
				linesRemoved++
				continue
			} else if strings.Contains(strings.ToLower(lines[i]), "license") {
				ignoreFolderLock = true
				linesRemoved++
				continue
			} else if strings.Contains(strings.ToLower(lines[i]), fmt.Sprintf("---.git")) {
				ignoreFolderLock = true
				linesRemoved++
				continue
			}
		}
		if !ignoreLine {
			for _, fileType := range data.Ignore.FileTypes {
				if strings.Contains(strings.ToLower(lines[i]), fmt.Sprintf("%s%s", ".", fileType)) {
					ignoreLine = true
					break
				}
			}
		}
		if !ignoreLine {
			for _, partial := range data.Ignore.Partials {
				if strings.Contains(strings.ToLower(lines[i]), partial) {
					ignoreLine = true
					break
				}
			}
		}
		if !ignoreLine {
			for _, fileName := range data.Ignore.FileNames {
				if strings.Contains(strings.ToLower(lines[i]), fileName) {
					ignoreLine = true
					break
				}
			}
		}
		if ignoreLine {
			linesRemoved++
			continue
		}
		if strings.ToLower(data.Output.Type) == "md" {
			lines[i] = "<br>" + lines[i]
		}

		output += lines[i] + "\n"
	}
	fmt.Printf("---Removed %v lines. ", linesRemoved)

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
func getFolderCount(line string) int {
	count := 0
	sep := []rune("|")

	for _, r := range []rune(line) {
		if r == sep[0] {
			count++
		}
	}
	return count
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
