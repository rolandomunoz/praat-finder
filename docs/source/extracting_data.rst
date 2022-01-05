Extracting data
---------------

When you make a Search, you can extract the audio and transcription parts that correspond
to the found items. Each extracted item will be stored in file pairs: a sound file
in WAV format and its TextGrid.

Extractig words as files
~~~~~~~~~~~~~~~~~~~~~~~~

In this section, we will extract the transcribed words along with their
audio files in a set of files. For this example, we will work with the files
in the folder ``recording sessions`` of the **Corpus for Spanish Vowels**.
As you can see in :numref:`corpus-recording_sessions`, TextGrids and sound files
come in pairs.

.. _corpus-recording_sessions:

.. figure:: img/corpus-recording_sessions.png
   :align: center

   A screenshot of the folder **recording sessions**

Each audio file contains the list of words in :ref:`spanish_words_list`
pronounced twice by one speaker.

.. _spanish_words_list:

.. csv-table:: List of Spanish words
   :header: "ID", "Word", "Gloss"
   :widths: 5, 8, 12

   1,"papa","*potato*"
   2,"pepa","*stone, pit*"
   3,"pipa","*pipe*"
   4,"popa","*stern (ship)*"
   5,"pupa","*pupa*"

In :numref:`corpus-long_sound` you can see an example in Praat. The TextGrid file
have two tiers: one for words, the tier ``word`` and the other for word segmentation,
the tier ``segment``.

.. _corpus-long_sound:

.. figure:: img/corpus-long_sound.png
   :align: center

   Sound file and its TextGrid in Praat for one speaker

To start, index the TextGrid files in the ``recording sessions`` folder
(see :doc:`01-create_index` for more information.).

.. _extract_data-index:

.. figure:: img/extract_data-index.png
   :align: center

   Indexing all TextGrid files in the `recording_sessions` folder.

Now, open the search window and copy the options in :numref:`extract_data-search_all`
to find all the transcribed items in the tier ``word``
(See :doc:`02-search` for more information).

.. _extract_data-search_all:

.. figure:: img/extract_data-search_all.png
   :align: center

   Indexing all TextGrid files in the `recording_sessions` folder.

Finally, in the submenu ``Finder > Tasks``, click on the ``Extract files...``
command. A window similar to :numref:`extract_data-extract_window` will
pop up.

.. _extract_data-extract_window:

.. figure:: img/extract_data-extract_window.png
   :align: center

   The ``Extract files`` window.

There are many fields! Don't worry. At this moment, only focus on the ``Save in``
field. Complete this field with the directory where the extracted files will be
stored in you machine. In my case, I filled it up with the path
``C:\Users\rolan\Desktop\words``. Now press on ``Ok`` and take a look to the
directory you selected. It should look like in :numref:`extract_data-destiny_folder`

.. _extract_data-destiny_folder:

.. figure:: img/extract_data-destiny_folder.png
   :align: center

   The extracted files in the destiny directory.

The resulting files keeps the original name of the file they come from and a suffix
indicating the 
