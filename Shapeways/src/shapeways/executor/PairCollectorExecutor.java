

package shapeways.executor;

import java.io.IOException;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;
import shapeways.algo.DataSink;
import shapeways.algo.PairCollector;

/**
 * The main class that runs the pair collector 
 * Requires an input and an output path
 * @author Udita
 */
public class PairCollectorExecutor {
    

    public static void main(String[] args) {
        
        Scanner scanner = new Scanner(System.in);
        
        // take the input path
        System.out.println("Please specify an input path : ");
        String inputPath = scanner.nextLine();
        
        // take the output path 
        System.out.println("Please specify an output path : ");                
        String outputPath = scanner.nextLine();
        try {
            
            // instantiate  data sink
            DataSink dataSink = new DataSink(); 
            
            // load the data in the sink
            dataSink.loadData(inputPath); 
            
            // instantiate pair collector
            PairCollector pairCollector = new PairCollector();
            
            // collect the pairs of atrists with atleast 50 common followers
            long startTime = System.currentTimeMillis();
            pairCollector.collectPair(outputPath, dataSink);
            long endTime = System.currentTimeMillis();
            
            System.out.println(String.format("Total time taken : %d millisecond(s)", (endTime - startTime)));
                    
        } catch (IOException ex) {
            Logger.getLogger(PairCollectorExecutor.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
