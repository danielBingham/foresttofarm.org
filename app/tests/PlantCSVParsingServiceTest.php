<?php

class PlantCSVParsingServiceTest extends TestCase {

    public function setUp() {
        parent::setUp();
        $this->csvService = new PlantCSVParsingService();

    }

    public function testParseLightTolerancesWithGoodData() {
        $fixtures = [
            ['test'=>'Sun;Partial', 'result'=>[1,2]],
            ['test'=> 'Sun;Shade', 'result'=>[1,3]],
            ['test'=>'Sun;Partial;Shade', 'result'=>[1,2,3]],
            ['test'=>'Partial;Shade', 'result'=>[2,3]],
            ['test'=>'Shade;Partial;Sun', 'result'=>[3,2,1]],
            ['test'=>'','result'=>[]]
        ];

        foreach($fixtures as $fixture) {
            $result = $this->csvService->parseLightTolerances($fixture['test']);
            $this->assertEquals($fixture['result'], $result);
        }
    }

    public function testParseLightTolerancesWithBadData() {
        $fixtures = [
            ['test'=>'sun;Partial', 'result'=>[2]],
            ['test'=>'Suun;Shade', 'result'=>[3]],
            ['test'=>'Sun;Sun;Shade', 'result'=>[1,3]],
            ['test'=>'Sun,Shade', 'result'=>[]],
            ['test'=>'Sun;Partial;Shade;Cloudy', 'result'=>[1,2,3]],
            ['test'=>'Sun;Partial;', 'result'=>[1,2]]
        ];

        foreach($fixtures as $fixture) {
            $result = $this->csvService->parseLightTolerances($fixture['test']);
            $this->assertEquals($fixture['result'], $result);
        }
    }

    public function testParseMoistureTolerancesWithGoodData() {
        $fixtures = [
            ['test'=>'Xeric;Mesic', 'result'=>[1,2]],
            ['test'=>'Xeric', 'result'=>[1]],
            ['test'=>'Mesic;Hydric', 'result'=>[2,3]],
            ['test'=>'Hydric;Mesic;Xeric', 'result'=>[3,2,1]],
            ['test'=>'Xeric;Mesic;Hydric', 'result'=>[1,2,3]],
            ['test'=>'Xeric; Mesic; Hydric', 'result'=>[1,2,3]],
            ['test'=>'', 'result'=>[]]
        ];

        foreach($fixtures as $fixture) {
            $result = $this->csvService->parseMoistureTolerances($fixture['test']);
            $this->assertEquals($fixture['result'], $result);
        }

    }

    public function testParseMoistureTolerancesWithBadData() {
        $fixtures = [
            ['test'=>'xeric;Mesic', 'result'=>[2]],
            ['test'=>'Xeric;Partial', 'result'=>[1]],
            ['test'=>'Xeeric;Mesic', 'result'=>[2]],
            ['test'=>'Xeric;Xeric;Mesic', 'result'=>[1,2]],
            ['test'=>'Xeric,Mesic;Hydric', 'result'=>[3]],
            ['test'=>'Xeric;Mesic;Watery', 'result'=>[1,2]],
            ['test'=>'Xeric;Mesic;', 'result'=>[1,2]]
        ];

        foreach($fixtures as $fixture) {
            $result = $this->csvService->parseMoistureTolerances($fixture['test']);
            $this->assertEquals($fixture['result'], $result);
        }
    }

    public function testParsePhWithGoodData() {
        $fixtures = [
            ['test'=>'0:0:2:0', 'result'=>[6.1,7.0]],
            ['test'=>'2:2:2:2', 'result'=>[3.5,8.5]],
            ['test'=>'1:2:2:1', 'result'=>[4.0,7.8]],
            ['test'=>'0:1:2:1', 'result'=>[5.35,7.8]],
            ['test'=>'1:2:1:0', 'result'=>[4.0,6.8]],
            ['test'=>'1:1:0:0', 'result'=>[4.0,5.8]],
            ['test'=>'0:0:1:1', 'result'=>[6.35,7.8]],
            ['test'=>'1:0:0:0', 'result'=>[4.0,4.5]],
            ['test'=>'0:1:0:0', 'result'=>[5.35,5.8]],
            ['test'=>'0:0:1:0', 'result'=>[6.35,6.8]],
            ['test'=>'0:0:0:1', 'result'=>[7.5,7.8]]
        ];

        foreach($fixtures as $fixture) {
            $result = $this->csvService->parsePH($fixture['test']);
            $this->assertEquals($fixture['result'], $result);
        }
    }

    public function testParsePhWithBadData() {
        $fixtures = [
            ['test'=>'0:3:2:1', 'result'=>[6.1,7.8]],
            ['test'=>'0:0:0:0', 'result'=>[6.1,7.0]],
            ['test'=>'0:2;2:0', 'result'=>[6.1,7.0]],
            ['test'=>'-1:0:2:1', 'result'=>[6.1,7.8]]
        ];

        foreach($fixtures as $fixture) {
            $result = $this->csvService->parsePH($fixture['test']);
            $this->assertEquals($fixture['result'], $result);
        }

    }

    public function testZoneWithGoodData() {
        $fixtures = [
            ['test'=>'3 - 7', 'result'=>['3','7']],
            ['test'=>'3b', 'result'=>['3b',null]],
            ['test'=>'7-10', 'result'=>['7','10']],
            ['test'=>'2', 'result'=>['2',null]]
        ];

        foreach($fixtures as $fixture) {
            $result = $this->csvService->parseZone($fixture['test']);
            $this->assertEquals($fixture['result'], $result);
        }
    }

    public function testZoneWithBadData() {
        $fixtures = [
            ['test'=>'3_7', 'result'=>[null, null]],
            ['test'=>'20', 'result'=>[null, null]],
            ['test'=>'3c',  'result'=>[null, null]]
        ];

        foreach($fixtures as $fixture) {
            $result = $this->csvService->parseZone($fixture['test']);
            $this->assertEquals($fixture['result'], $result);
        }
    }

}
