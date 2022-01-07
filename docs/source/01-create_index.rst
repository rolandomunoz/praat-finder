Step 1: Indexing TextGrids
--------------------------

Indexing your TextGrid files is the first step to do before any task. This consists in telling
the plug-in where the annotation files are. By doing so, Praat will look for all
TextGrid files under a certain directory and will index their content internally.

First, let's start by indexing the TextGrids in the folder ``tutorial/vowels/speaker_001``
of the **example files**. In :numref:`speaker_001-folder` there is a screenshot of that folder.

.. _speaker_001-folder:

.. figure:: img/speaker_001-folder.png
   :align: center

   A folder containing the audio and TextGrid files to be indexed.

To index the said folder, go to the ``Finder > Create index...`` command. When you click on it,
a window as in :numref:`index_window` pops up. In the field
``Folder with annotation files`` provide the directory of the folder in your machine.
Leave the other options as in :numref:`index_window` and press on ``Ok``.

.. _index_window:

.. figure:: img/index_window.png
   :align: center

   The ``Create index...`` window

When the index is done, the ``Praat Info`` window will show the message in
:numref:`index-result_window`. The message lists all the tiers that where
found in your TextGrids and the sum of the number of transcribed items
(``intervals`` or ``points``) for each case. For example, the tier ``segment``
contains 20 labels in total.

.. _index-result_window:

.. figure:: img/index-result_window.png
   :align: center

   The ``Praat Info`` window showing the indexing results

.. _TextGrids in subfolders:

Index subfolders
~~~~~~~~~~~~~~~~
It is common that TextGrid files are stored in various subfolders under a directory.
To index those files, check the ``Process subfolders as well`` of the ``Create index`` window
(see :numref:`index_window`).

For this example, we will index the TextGrid files in the folder ``tutorial/vowels`` of the
**examples files**. These TextGrids are organized in subfolders for each speaker.

First, let's identify the directory that contains the subfolders with the target files.
In my computer, the directory is ``C:\Users\rolan\Desktop\spanish_vowels`` as you
can see in the :numref:`corpus_for_spanish_vowel-folder`.

.. _corpus_for_spanish_vowel-folder:

.. figure:: img/corpus_for_spanish_vowels-folder.png
   :align: center

   The directory containing the subfolders with the TextGrid files in the ``vowels`` folder.

Once you have the directory path, copy it and open the ``Create index`` window.
Fill up the window with the copied path and check the ``Process subfolders as well``
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

Now you are ready to for :doc:`02-search`.
