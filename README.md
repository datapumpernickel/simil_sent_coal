# Who wrote it? - Coalition Negotiations in Germany

In this little piece of code, I embed the different party programs of the government coalition parties in Germany into one embedding space. I use sentence-transformers to embed each individual sentence. 

With the also embedded coalition agreement, I create a cosine-distance matrix for each sentence pair between each party program and the coalition agreement to find the sentence from the 
party agreement that matches best with the sentence in the coalition agreement. 

This makes it possible to trace individual policy proposals from the coalition agreement to parties via automated ways. 

Caveat: The cosine similarity at times is misleading and high value (even above .8) turn out not to be matches of sentences to the human gold standard. 
