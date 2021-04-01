package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"strings"
)

func main() {

	fmt.Println("	Readme tree creator started - looking for readme markdown files")

	fileName := "README.md"

	if _, err := os.Stat(fileName); os.IsNotExist(err) {

		fileNameLower := "readme.md"

		if _, err := os.Stat(fileNameLower); os.IsNotExist(err) {

			fmt.Println("Error could not find a readme markdown file - creating...")

			createFile()

		} else {
			fileName = fileNameLower
		}
	}

	fmt.Print("	Comparing dir trees ")

	cmdStr := "tree /a /f >" + fileName
	c := exec.Command("cmd", "/C", cmdStr)
	if err := c.Run(); err != nil {
		fmt.Println("Error: ", err)
		os.Exit(1)
	}

	fmt.Print(".")

	input, err := ioutil.ReadFile(fileName)
	if err != nil {
		fmt.Println("Error: ", err)
		os.Exit(1)
	}

	fmt.Print(".")

	lines := strings.Split(string(input), "\n")

	//lines 0,1 are drive info
	for i := 0; i < 2; i++ {
		lines[i] = ""
	}

	fmt.Print(".")

	output := ""

	for i := 2; i < len(lines); i++ {

		//Remove Images and checkpoints
		if !(isEmptyLine(lines[i]) || strings.Contains(strings.ToLower(lines[i]), ".png") || strings.Contains(strings.ToLower(lines[i]), ".jpg") || strings.Contains(strings.ToLower(lines[i]), ".jpeg") || strings.Contains(strings.ToLower(lines[i]), "---images") || strings.Contains(strings.ToLower(lines[i]), "---.ipynb_checkpoints") || strings.Contains(strings.ToLower(lines[i]), "-checkpoint.ipynb")) {

			lines[i] = "<br>" + lines[i]

			output += lines[i] + "\n"
		}
	}

	fmt.Println(" writing updates.")

	output = "# Jupyter Notebooks\n\n### Created using ReadmeTree.go\n<pre>" + output + "\n</pre>"

	err = ioutil.WriteFile(fileName, []byte(output), 0644)
	if err != nil {
		fmt.Println("Error could not edit readme markdown file")
		os.Exit(1)
	}

	fmt.Println("--> git readme file formatted.")
}

func createFile() {
	err := ioutil.WriteFile("README.md", []byte(""), 0755)
	if err != nil {
		fmt.Printf("Unable to write file: %v", err)
		os.Exit(1)
	}
}

func isEmptyLine(line string) bool {
	result := strings.ReplaceAll(line, " ", "")
	result2 := strings.ReplaceAll(result, "|", "")
	result3 := strings.TrimSpace(result2)

	if len(result3) == 0 {
		return true
	}
	if result3 == "" {
		return true
	}
	return false
}
