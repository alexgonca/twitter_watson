# How to use IBM Watson to analyse Twitter data

A friend of mine wanted to use natural language processing (NLP) to analyse
the tweets by French presidential candidate Eric Zemmour. This is how we went about it.

All tools mentioned in this tutorial are free (Google Sheets, Twitter API),
open source (Facepager, DB Browser for SQLite), or freemium (IBM Watson).

## Collecting the Tweets

We used [Facepager](https://github.com/strohne/Facepager) to collect the tweets.
This tool comes with a number of useful [presets](https://github.com/strohne/Facepager/wiki/Presets).
We took advantage of a preset titled `Twitter >> Get tweets of user` and tweaked the parameters accordingly.

## Analysing the Data with IBM Watson

We also used Facepager to submit the tweets to IBM Watson's [Natural Language Understanding](https://www.ibm.com/cloud/watson-natural-language-understanding),
a reputable NLP cloud solution, and retrieve the responses.

To make it easier for other people to reproduce this step, we created [this Facepager
preset for IBM Watson's Natural Language Understanding](/facepager_preset_for_ibm_watson.json).

We were interested in extracting keywords, concepts, categories, sentiment, and entities from
those tweets. You can read [this documentation to learn about IBM Watson's NLP capabilities](https://cloud.ibm.com/apidocs/natural-language-understanding).

## Exporting the Data

We could [export data as CSV files](https://github.com/strohne/Facepager/wiki/Export-Data)
directly from Facepager, but we decided to take a different route in order to have more
control over the output.

Facepager stores data as [SQLite files](https://www.sqlite.org/index.html). We opened our SQLite file on [DB Browser for SQLite](https://sqlitebrowser.org/).
Then we created views to query the data according to our needs.
We published in this repository the [SQL statements used to create those views](/sqlite_views.sql).
To understand those statements, it is useful to have a basic knowledge of SQL and read the documentation on SQLite's [JSON1 Extension](https://www.sqlite.org/json1.html).

As an example, we also published in this repository [our SQLite file with tweets, IBM Watson's analyses,
and our customized views](/zemmour.zip).

## Playing with the data on Google Sheets

On DB Browser for SQLite, we exported all views as CSV files and [imported them on Google Sheets](https://support.google.com/docs/answer/40608).

Then, on Google Sheets, we created
[pivot tables](https://support.google.com/docs/answer/1272900) and [a couple of charts](https://support.google.com/docs/answer/63824) to make sense of the data.

There is a [copy of the resulting spreadsheet here](https://docs.google.com/spreadsheets/d/1murWQ5kay3Gl9GBLOz21FgtZvbOEvMXzacbnq6LBb3U/edit?usp=sharing).