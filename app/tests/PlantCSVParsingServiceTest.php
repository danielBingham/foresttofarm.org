<?php

class PlantCSVParsingServiceTest extends TestCase {

    public function setUp() {
        $this->csvService = new PlantCSVParsingService();

    }

    public function testParseLightTolerancesWithGoodData() {
        $fixtures = array(
            array('test'=>'Sun;Partial', 'result'=>array(1,2)),
            array('test'=> 'Sun;Shade', 'result'=>array(1,3)),
            array('test'=>'Sun;Partial;Shade', 'result'=>array(1,2,3)),
            array('test'=>'Partial;Shade', 'result'=>array(2,3)),
            array('test'=>'Shade;Partial;Sun', 'result'=>array(3,2,1)),
            array('test'=>'','result'=>array())
        );

        foreach($fixtures as $fixture) {
            $result = $this->csvService->parseLightTolerances($fixture['test']);
            $this->assertEqual($result, $fixture['result']);
        }
    }

    public function testParseLightTolerancesWithBadData() {
        $fixtures = array(
            array('test'=>'sun;Partial', 'result'=>array(2)),
            array('test'=>'Suun;Shade', 'result'=>array(3)),
            array('test'=>'Sun;Sun;Shade', 'result'=>array(1,3)),
            array('test'=>'Sun,Shade', 'result'=>array()),
            array('test'=>'Sun;Partial;Shade;Cloudy', 'result'=>array(1,2,3))
        );

        foreach($fixtures as $fixture) {
            $result = $this->csvService->parseLightTolerances($fixture['test']);
            $this->assertEqual($result, $fixture['result']);
        }
    }

}
