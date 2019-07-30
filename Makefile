include .env

default: run

run:
	mix run -e 'BlogPostman.run()'

compile:
	mix compile