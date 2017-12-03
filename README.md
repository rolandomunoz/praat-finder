# Indexer

This Praat plug-in is a *search engine* which helps the user to find some specific annotations stored in TextGrid files inside a folder. Once a search is done, you can visualize the occurences ony-by-one in the TextGridEditor or extract them in a folder.

## Getting started

#### Requirements
Before starting, make sure that you have Praat 6.0.30 or more on your computer. If not, download the the latest version of Praat ![here](http://www.fon.hum.uva.nl/praat). 

### 1. How to install it?

**Step 1:** Download the plug-in from this website. Then unzip it. 

**Step 2:** Drop the plug-in folder in the *praat preference* folder.

*On Mac* 

*On Windows*

*On Ubuntu* go to `/home/rolando/.praat-dir`

**Step 3:** Open Praat again. In the Object menu, go to `Praat > Goodies`. You should see a submenu called `Indexer` 

### 2. How to use it?

This plug-in is simple to use. You just need to follow three steps.

#### Step 1: Create an index

In the first step, you need to tell the plug-in to capture all the annotations stored in TextGrid files inside a folder. This is done by using the `Create an index...` command. 

If all your TextGrid files are stored below a folder, provide this path in the **Textgrid folder** field. Then, press **Continue**

![Screenshot_from_2017-12-03_15-37-16](/uploads/7eead1075e7be1ac7e4c00de4db9ea2d/Screenshot_from_2017-12-03_15-37-16.png)

Sometimes, TextGrid files are stored in different folders. In these cases, in **TextGrid folder**, provide the folder path which contains the TextGrid subfolders. Then, check the **Recursive search** option. 
By doing so, all the TextGrids under the domain of the **TextGrid folder** path will be captured by the plug-in.

![Screenshot_from_2017-12-03_15-58-31](/uploads/d641462c4d0a53e0b3e4a05b1342024f/Screenshot_from_2017-12-03_15-58-31.png)

Empty spaces are not considered part of the annotations, so they are not tipically include in the index. If it is neccesary, you can use the **Include empty intervals** option to capture these intervals as part of the index.

#### Step 2: Make a query

Once a we created an index, we are ready to make queries. 

#### Step 3: Do some actions!

## Some ideas to use this plug-in

### List all the words in a corpus

### Find specific information

## How to cite thisp plug-in?

- Rolando Muñoz
