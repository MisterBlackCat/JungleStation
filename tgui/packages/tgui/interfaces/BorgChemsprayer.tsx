import { useBackend } from '../backend';
import { Button, Flex, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

type BorgChemsprayerContext = {
  maxVolume: number;
  theme: string;
  reagents: Reagent[];
  selectedReagent: string;
};

type Reagent = {
  name: string;
  volume: number;
  description: string;
};

export const BorgChemsprayer = (props, context) => {
  const { data } = useBackend<BorgChemsprayerContext>(context);
  const { maxVolume, theme, reagents, selectedReagent } = data;

  const dynamicHeight = reagents.length * 25 + 60;

  return (
    <Window width={400} height={dynamicHeight} theme={theme}>
      <Window.Content>
        <Section>
          <ReagentDisplay
            reagents={reagents}
            selected={selectedReagent}
            maxVolume={maxVolume}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};

const ReagentDisplay = (props, context) => {
  const { act } = useBackend(context);
  const { reagents, selected, maxVolume } = props;
  if (reagents.length === 0) {
    return <NoticeBox>No reagents available!</NoticeBox>;
  }
  return reagents.map((reagent) => (
    <Flex key={reagent.name} m={0.5}>
      <Flex.Item grow textAlign={'left'}>
        {reagent.name}
      </Flex.Item>
      <Flex.Item mx={1}>
        <Button
          icon={'info-circle'}
          textAlign={'center'}
          tooltip={reagent.description}
        />
      </Flex.Item>
      <Flex.Item textAlign={'right'}>
        <Button
          icon={'syringe'}
          color={reagent.name === selected ? 'green' : 'default'}
          content={'Select'}
          textAlign={'center'}
          onClick={() => act(reagent.name)}
        />
      </Flex.Item>
    </Flex>
  ));
};
