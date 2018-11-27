# Onliner scrapper

Scraps articles and some info about them using Capybara and Selenium web driver

## Installation

First of all, you need to download and add to `$PATH` One of web drivers depending on your browser (and, of course, browser itself). For Firefox, you can do it by downloading driver [here](https://github.com/mozilla/geckodriver/releases) and placing it, for example, into `~/.local/bin`.

Then, install required gems

```bash
bundle install
```

## Running

Run app by executing

```bash
./scrap.sh
```