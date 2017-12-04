# Indexer

This Praat plug-in is a *search engine* which helps the user to find some specific annotations within a set of TextGrid files stored in a directory. Once a search is done, you can visualize the occurences ony-by-one in the TextGridEditor or extract them in a folder.

## Getting started


### 1. How to install it?

Before starting, make sure that you have Praat 6.0.30 or more on your computer. If not, download the the latest version of Praat ![here](http://www.fon.hum.uva.nl/praat). 

You can install the plug-in in two ways. 

#### 1.1 Copy the plug-in folder to Praat preferences

**Step 1:** Download the plug-in from this website. Then unzip it. 

**Step 2:** Drop the plug-in folder in the *praat preference* folder.

*On Mac* 

*On Windows*

*On Ubuntu*, go to `/home/rolando/.praat-dir`

**Step 3:** Open Praat again. In the Object menu, go to `Praat > Goodies`. You should see a submenu called `Indexer` 

#### 1.2 Run the set-up file



### 2. How to use it?

This plug-in is simple to use. You just need to follow three steps.

#### Step 1: Create an index

First, in the plug-in menu, use the `Create an index...` command to index the content of your TextGrid files. 
You can think of this command as a panoramic photo in the sense that all your annotations at a specific moment will be captured and stored in a file. 
The result file will be used by the other commands to make simple or complex queries about the content of the annotations. 

When you press on `Create an index...` a dialogue box will pop-up. In the `TextGrid folder` field, complete with the directory where your TextGrids are stored. 
Very often, projects organized TextGrid files in different subfolders within a *main folder*. In these cases, complete the `TextGrid folder` field with the path of the *main folder*.
Then, activate the `Recursive search` option. This way, any TextGrid below the main folder domain will be listed in the index.<br>
Finally, *empty intervals* are not considered as part of the annotations, so they are not tipically include in the index. 
If it is neccesary, you can revert this behaviour by using the **Include empty intervals** option.

![Screenshot_from_2017-12-04_16-16-35](/uploads/47a4971af56b7f6ad25f576382d4e5d5/Screenshot_from_2017-12-04_16-16-35.png)

When press on **Continue**, wait until a message appears. 
In the end, you will see a table object  called **index**.
This table contains the representation of all your indexed TextGrids.
This table is shown only for informantion purposes. You can remove it if want. 

#### Step 2: Make a query

Once we created an index, it is now possible to make queries! By doing a query, we can tell the plug-in to group all the annotations that match a specific text.

![Screenshot_from_2017-12-04_17-22-53](/uploads/6e308dcaca58ca27bce02153c619146f/Screenshot_from_2017-12-04_17-22-53.png)

#### Step 3: Do some actions!

## Advanced features


## Some ideas to use this plug-in

### List all the words in a corpus

### Find specific information

## How to cite this plug-in?

`Muñoz A., Rolando (2017). Indexer[Praat plug-in]. Version 0.0.1, retrived 17 October 2017 from https://gitlab.com/praat_plugins_rma/plugin_indexer`

