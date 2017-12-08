# Indexer

This Praat plug-in is a *search engine* which helps you to find some specific annotations within a set of TextGrid files stored in a directory. 
Once a search is done, you can visualize the occurences ony-by-one in the TextGridEditor or extract them in a folder.

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
You can think of this command as a panoramic photo in the sense that all your annotations at a specific moment are captured. 
If any modification is done to the TextGrids later, this will not be included in the photo, 
The result file will be used by the other commands to make queries about the content of the annotations. 

When you press on `Create an index...` a dialogue box will pop-up. 
In the `TextGrid folder` field, complete with the directory where your TextGrids are stored. 
Very often, projects organized TextGrid files in different subfolders within a *main folder*.
In these cases, complete the `TextGrid folder` field with the path of the *main folder*.
Then, activate the `Recursive search` option. This way, any TextGrid below the main folder domain will be listed in the index.<br>
Finally, *empty intervals* are not considered as part of the annotations, so they are not tipically include in the index. 
If it is neccesary, you can revert this behaviour by using the **Include empty intervals** option.

![Screenshot_from_2017-12-04_16-16-35](/uploads/47a4971af56b7f6ad25f576382d4e5d5/Screenshot_from_2017-12-04_16-16-35.png)

When press on **Continue**, wait until a message appears. 
In the end, you will see a table object called **index**.
This table contains the representation of all your indexed TextGrids. You can optionally remove it.

#### Step 2: Make a query

Once you are done with step 1, it is time for queries! 
When you make a query, you ask the plug-in to find those TextGrid intervals that contain a text in a specific tier. 

In the plug-in menu, go to `Query by tier name...`, a dialog box will appear.
In `Tier name`, pick the tier where the query will be made, then complete the `Search for` with the text you want find.
Use `Mode` to set the type of matching. There are several possibilities: *is equal to*, *contains*, *starts with* or *starts with*. 
You can also do negative searches: *is not equal*, *does not contain*, *does not start with* or *does not end with*. 
For more complex searches, you can use [regular expressions](http://www.fon.hum.uva.nl/praat/manual/Regular_expressions.html): *matches (regex)*.

![Screenshot_from_2017-12-04_17-22-53](/uploads/6e308dcaca58ca27bce02153c619146f/Screenshot_from_2017-12-04_17-22-53.png)

When press on **Continue**, wait until a message is shown.
The message will tell you how many occurrences were found. 
Also, a query table will be shown in Praat Objects.
This contains details of the occurrences found. Feel free to remove.

Usually, you don't need to go back to step 1 each time you make a query. Step 2 can be realised as many times as neccesary!

#### Step 3: Do some actions!

After making a query, you can do some tasks.

##### Browsing on your annotations

You can inspect each matched interval along with its audio file in the [TextGridEditor](http://www.fon.hum.uva.nl/praat/manual/TextGridEditor.html) window.

To do this, go to the plug-in menu and click on `Do > View & Edit files...`.

![Screenshot_from_2017-12-05_23-58-59](/uploads/b0eb3d562674aab282c6a0e2bbddd1cb/Screenshot_from_2017-12-05_23-58-59.png)

In the dialog box, enter the directories where your TextGrid and audio files are stored.
Before doing this, notice that the `TextGrid folder` section is already completed, so you can skip it. 
On the other hand, observe that there is dot (`.`) in the `Audio folder` field and that the option `Relative to TextGrid paths` is checked. 
For the plug-in, this means:  "look for the audio files in the same directory as in the TextGrids".
You can do the same task by unchecking the `Relaive to TextGrid paths` and duplicating the `TextGrid folder`'s path in `Audio folder`.

##### Extract your files

![Screenshot_from_2017-12-05_23-59-21](/uploads/bf2053af32cf00dfe8c0c7617a657152/Screenshot_from_2017-12-05_23-59-21.png)

## Advanced features


se this plug-in

### List all the words in a corpus

### Find specific information

## Author

- Rolando Muñoz Aramburú

## License

This project is licensed under the GNU GPL terms - see the [LICENSE.md](https://gitlab.com/praat_plugins_rma/plugin_tokenizer/blob/master/LICENSE)
 file for details.

## How to cite this plug-in?

`Muñoz A., Rolando (2017). Indexer[Praat plug-in]. Version 0.0.1, retrived 17 October 2017 from https://gitlab.com/praat_plugins_rma/plugin_indexer`

