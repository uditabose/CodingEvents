/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package shapeways.others;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author Udita <udita.bose@nyu.edu>
 */
public class RepeatedCharactersTest {
    
    public RepeatedCharactersTest() {
    }
    
    @BeforeClass
    public static void setUpClass() {
    }
    
    @AfterClass
    public static void tearDownClass() {
    }
    
    @Before
    public void setUp() {
    }
    
    @After
    public void tearDown() {
    }

    @Test
    public void testReplaceRepeatedCharacters() {
        String aTestString = "sssssTTTTTToNNps";
        
        assertEquals(" Strings should match ", "s5T6oN2ps"
                , RepeatedCharacters.replaceRepeatedCharacters(aTestString));
        
        aTestString = "sssssTTTTTToNNpsaaaa";
        assertEquals(" Strings should match ", "s5T6oN2psa4"
                , RepeatedCharacters.replaceRepeatedCharacters(aTestString));
        
        aTestString = "sTTTTTToNNpsaaaa";
        assertEquals(" Strings should match ", "sT6oN2psa4"
                , RepeatedCharacters.replaceRepeatedCharacters(aTestString));
        
        aTestString = "sToNps";
        assertEquals(" Strings should match ", aTestString
                , RepeatedCharacters.replaceRepeatedCharacters(aTestString));
    }
    
}
