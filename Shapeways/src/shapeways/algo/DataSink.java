

package shapeways.algo;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import shapeways.bean.Artist;
import shapeways.bean.Follower;


/**
 * The data sink, responsible for reading and persisting the
 * follower and artist data in format that is convenient for 
 * the pair collector algorithm to consume.
 * 
 * @author Udita
 */
public class DataSink {
    
    // a map containing all artists keyed by artist name
    private final Map<String, Artist> allArtists;

    /**
     * DataSink constructor, initializes maps 
     */
    public DataSink() {
        this.allArtists = new HashMap<>();
    }
    
    /**
     * loads follower-artist the data from the flat file, and creates the 
     * necessary maps.
     * 
     * @param dataFilePath follower-artist data containing flat file path
     * @throws IOException 
     */
    public void loadData(String dataFilePath) throws IOException {
        // the input file handler
        File dataFile = new File(dataFilePath);
        
        // if the file path is invalid, stop execution
        if (!dataFile.exists() || !dataFile.isFile()) {
            throw new IOException(String.format("%s does not exist", dataFilePath));
        }
        
        // the file reader
        BufferedReader dataFileReader = new BufferedReader(new FileReader(dataFile));
        
        String readLine = null;
        int userId = 1;
        Follower follower = null;
        Artist artist = null;
        
        // reads the file by line. each line corresponds to one follower,
        // the artist names are comma separated values 
        while((readLine = dataFileReader.readLine()) != null) {
            
            // instantiated a new user 
            follower = new Follower(userId++);
            
            // artists names liked by a follower
            String[] artistsArray = readLine.split(",");
            
            // store the artist info 
            for(String artistName : artistsArray) {
                
                if (allArtists.containsKey(artistName)) {
                    
                    // already recognized artist, use the existing artist info
                    artist = allArtists.get(artistName);
                } else {
                    
                    // a new artist
                    artist = new Artist(artistName);
                    
                    // add the artist in persistent map
                    allArtists.put(artistName, artist);
                }
                
                // link the follower with artist
                artist.addFollower(follower);
                artist = null;
            }
            follower = null;
        }     
    }
    
    public Set<Artist> getAllArtists() {
        return new HashSet<>(this.allArtists.values());
    }

}
