Step 1: Indexing TextGrids
--------------------------

Indexing your TextGrid files is the first step to do before any task. This consists in telling
the plug-in where the annotation files are. By doing so, Praat will look for all
TextGrid files under a certain directory and will index their content internally.

First, let's start by indexing the files within the folder *speaker_001* of the **corpus for
spanish vowels**. In :numref:`speaker_001-folder` there is a screenshot of that folder.

.. _speaker_001-folder:

.. figure:: img/speaker_001-folder.png
   :align: center

   A folder containing the audio and TextGrid files to be indexed.

To index the said folder, go to the ``Finder > Create index...`` command and click on it.
A window as in :numref:`index_window` will pop-up. In ``Folder with annotation files``
provide the directory of the folder in your machine. Leave the other options as in
:numref:`index_window` and press on ``Ok``

.. _index_window:

.. figure:: img/index_window.png
   :align: center

   The ``Create index...`` window

When the index is done, a message will appear in the ``Praat Info`` as in
:numref:`index-result_window`. The message show a summary of all tiers in
the TextGrid files. For example, the tier ``segment`` contains 20 labels.

.. _index-result_window:

.. figure:: img/index-result_window.png
   :align: center

   The ``Praat Info`` window showing the indexing results

TextGrids in subfolders
~~~~~~~~~~~~~~~~~~~~~~~
It is common that TextGrid files are stored in various subfolders within a common directory.
To index those files, check the ``Process subfolders as well`` of the ``Create index`` window
(see :numref:`index_window`).

Let's index all TextGrids in the **Corpus for Spanish Vowels**. First, let's identify the
directory that contains those files. In my computer, the directory is
``C:\Users\rolan\Desktop\spanish_vowels`` as you can see in the
:numref:`corpus_for_spanish_vowel-folder`.

.. _corpus_for_spanish_vowel-folder:

.. figure:: img/corpus_for_spanish_vowels-folder.png
   :align: center

   The directory containing all TextGrid files in the **Corpus for Spanish Vowels**

Once you have the directory path, copy it and go to the ``Finder > Create index...`` command.
Fill up the window with the path and check the ``Process subfolders as well``
option. Your window should looks similar to :numref:`index_window2`.

.. _index_window2:

.. figure:: img/index_window2.png
   :align: center

   The ``Create index...`` window

After pressing on ``Ok``, you should have the message in :numref:`index-result_window2`

.. _index-result_window2:

.. figure:: img/index-result_window2.png
   :align: center

   The ``Praat Info`` window showing the indexing results
