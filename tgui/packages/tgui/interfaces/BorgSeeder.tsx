import { useBackend } from '../backend';
import { Button, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

type BorgSeederContext = {
  theme: string;
  selectedReagent: string;
  fruits: Seeds[];
  vegetables: Seeds[];
  flowers: Seeds[];
  misc: Seeds[];
};

type Seeds = {
  name: string;
  description: string;
};

export const BorgSeeder = (props, context) => {
  const { data } = useBackend<BorgSeederContext>(context);
  const { theme, selectedReagent, fruits, vegetables, flowers, misc } = data;

  const dynamicHeight =
    Math.ceil(fruits.length / 2) * 20 +
    Math.ceil(vegetables.length / 2) * 20 +
    Math.ceil(flowers.length / 2) * 20 +
    Math.ceil(misc.length / 2) * 20 +
    20;

  return (
    <Window width={550} height={dynamicHeight} theme={theme}>
      <Window.Content>
        <Section title={'Fruits'}>
          <SeedDisplay seeds={fruits} selected={selectedReagent} />
        </Section>
        <Section title={'Vegetables'}>
          <SeedDisplay seeds={vegetables} selected={selectedReagent} />
        </Section>
        <Section title={'Flowers'}>
          <SeedDisplay seeds={flowers} selected={selectedReagent} />
        </Section>
        <Section title={'Misc'}>
          <SeedDisplay seeds={misc} selected={selectedReagent} />
        </Section>
      </Window.Content>
    </Window>
  );
};

const SeedDisplay = (props, context) => {
  const { act } = useBackend(context);
  const { seeds, selected } = props;
  if (seeds.length === 0) {
    return <NoticeBox>NO SEEDS AVAILABLE!</NoticeBox>;
  }
  return seeds.map((reagent) => (
    <Button
      key={reagent.id}
      icon="tint"
      width="250px"
      lineHeight={1.75}
      content={reagent.name}
      color={reagent.name === selected ? 'green' : 'default'}
      onClick={() => act(reagent.name)}
    />
  ));
};
