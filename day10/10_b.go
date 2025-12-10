package main

import (
	"fmt"
	"bufio"
	"os"
	"regexp"
	"strconv"
	"strings"
	"math"

  "github.com/draffensperger/golp"
)

func main() {
	file, err := os.Open("data")
	if err != nil {
		panic(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	// Regex patterns
	bracketPattern := regexp.MustCompile(`\[[^\]]*\]`)
	roundPattern := regexp.MustCompile(`\([0-9,\s]*\)`)
	curlyPattern := regexp.MustCompile(`\{[0-9,\s]*\}`)

	pass := 0
	lineNum := 1
	for scanner.Scan() {
		line := scanner.Text()

		// --- 1. Extract first component (ignored) ---
		ignored := bracketPattern.FindString(line)

		// --- 2. Extract arrays from round brackets ---
		roundMatches := roundPattern.FindAllString(line, -1)
		buttons := [][]float64{}

		for _, group := range roundMatches {
			trimmed := strings.Trim(group, "()")
			if trimmed == "" {
				buttons = append(buttons, []float64{})
				continue
			}
			numStr := strings.Split(trimmed, ",")
			row := []float64{}
			for _, n := range numStr {
				val, _ := strconv.ParseFloat(strings.TrimSpace(n), 64)
				row = append(row, val)
			}
			buttons = append(buttons, row)
		}

		// --- 3. Extract curly bracket array ---
		curly := curlyPattern.FindString(line)
		rhs := []float64{}
		if curly != "" {
			trimmed := strings.Trim(curly, "{}")
			numStr := strings.Split(trimmed, ",")
			for _, n := range numStr {
				val, _ := strconv.ParseFloat(strings.TrimSpace(n), 64)
				rhs = append(rhs, val)
			}
		}

		matrix := make([][]float64, len(rhs))
		for i := range matrix {
				matrix[i] = make([]float64, len(buttons))
		}

		for i, button := range buttons {
			for _, val := range button {
				matrix[int(val)][i] = 1
			}
		}

		fmt.Printf("Line %d:\n", lineNum)
		fmt.Printf("  Ignored: %s\n", ignored)
		fmt.Printf("  buttons: %#v\n", buttons)
		fmt.Printf("  RHS: %#v\n", rhs)
		fmt.Printf("  Matrix: %#v\n", matrix)

		c := make([]float64, len(buttons))
		for i := range c {
			c[i] = 1
		}
		val := solve(c, matrix, rhs)
		pass += val
		
		fmt.Printf("  Solution: %d\n", val)

		lineNum++
	}

	fmt.Printf("Final pass: %d\n", pass)
	if err := scanner.Err(); err != nil {
		panic(err)
	}
}

func solve(c []float64, A [][]float64, b []float64) int {
	lp := golp.NewLP(len(b), len(c))
	
	for i := range A {
		lp.AddConstraint(A[i], golp.EQ, b[i])
	}

	lp.SetObjFn(c)
	for i := range c {
		lp.SetInt(i, true)
	}

	lp.Solve()
	vars := lp.Variables()

	fmt.Printf("  Vars: %#v\n", vars)
	objective := 0
	for _, v := range vars {
		objective += int(math.Round(v))
	}

	return objective
}
